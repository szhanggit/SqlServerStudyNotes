CREATE PROCEDURE sp_MOMO_AddQuotation
    @QuotationNumber VARCHAR(50) ,
    @MasterProductCode VARCHAR(50) ,
    @ChildProductCode VARCHAR(50),
	@ApplyExpiryId INT = NULL,
	@ApplyExpiryDate DATETIME = NULL
AS
BEGIN
	DECLARE @ChildQuotaionId INT
	DECLARE @ChildQuotaionProductId INT
	DECLARE @ChildBusinessModelId INT;

	DECLARE @childBrandId INT;
	DECLARE @ChildProductVersionId INT
	DECLARE @ChildProductComboSetId INT

	DECLARE @MasterClientQuotationProductId INT
	DECLARE @masterSubType INT = NULL;

	SELECT	@childBrandId = childP.BrandId,
			@ChildProductVersionId = pcs.ChildProductVersionId,
			@ChildProductComboSetId = pcs.Id,
			@masterSubType = p.ProductSubType
		FROM dbo.Product p WITH(NOLOCK)
		JOIN dbo.ProductComboSet pcs WITH(NOLOCK) ON pcs.ProductComboId = p.ProductComboId
		JOIN dbo.Product childP WITH(NOLOCK) ON childP.Id = pcs.ChildProductId
		WHERE p.ProductCode = @MasterProductCode AND childP.ProductCode = @ChildProductCode

	SELECT TOP (1) 
			@ChildQuotaionId = childcqp.ClientQuotationId,
			@ChildBusinessModelId = childCQ.BusinessModelId,
			@MasterClientQuotationProductId = cqp.Id
		FROM dbo.Product p WITH(NOLOCK)
		JOIN dbo.ProductVersion pv WITH(NOLOCK) ON pv.ProductId = p.Id
		JOIN dbo.ClientQuotationProduct cqp WITH(NOLOCK) ON pv.Id = cqp.ProductVersionId
		JOIN dbo.ClientQuotation cq WITH(NOLOCK) ON cq.Id = cqp.ClientQuotationId
		JOIN dbo.ClientQuotationProductCombo cqpc WITH(NOLOCK) ON cqpc.ClientQuotationProductId = cqp.Id
		JOIN dbo.ClientQuotationProduct childcqp WITH(NOLOCK) ON cqpc.ChildClientQuotationProductId = childcqp.Id
		JOIN dbo.ClientQuotation childCQ WITH(NOLOCK) ON childCQ.Id = childcqp.ClientQuotationId
		WHERE p.ProductCode = @MasterProductCode and cq.QuotationNumber = @QuotationNumber

	SELECT @ChildQuotaionId; -- please don't delete

	IF(@ChildQuotaionId is null)
	BEGIN
		print 'Quotation:'+ @QuotationNumber +' MasterProduct:'+@MasterProductCode+' not ready!'
		RETURN;
	END

	IF EXISTS(select 1 from dbo.ClientQuotationProduct WITH(NOLOCK) WHERE ClientQuotationId = @ChildQuotaionId AND ProductVersionId = @ChildProductVersionId)
	BEGIN
		RETURN;
	END

	IF @ApplyExpiryId IS NULL
	BEGIN
		DECLARE @did INT = (SELECT TOP 1 Id FROM dbo.Dictionary WITH(NOLOCK) WHERE Name = 'FixEndOfDay' AND Category = 'ExpirationPolicyName')
		SET @ApplyExpiryId = (SELECT TOP 1 Id FROM dbo.ExpirationPolicy WITH(NOLOCK) WHERE DisplayNameId = @did)
		SET @ApplyExpiryDate = '2999-12-31 23:59:59.000';
	END

	INSERT INTO [dbo].[ClientQuotationProduct]
		([ClientQuotationId]
		,[ProductVersionId]
		,[ExpirySchemeId]
		,[MaxIssueVoucherNumber]
		,[CreatedBy]
		,[CreatedOn]
		,[Status]
		,[ApprovedBy]
		,[ApprovedOn]
		,[SystemProcessFee]
		,[ExpirationDate])
	SELECT TOP (1)
		@ChildQuotaionId,
		@ChildProductVersionId,
		@ApplyExpiryId,
		IIF(@masterSubType = 8 OR @masterSubType = 10, NULL, cqp.MaxIssueVoucherNumber) , -- super voucher 不设置
		'API',
		GETDATE(),
		32,
		'API',
		GETDATE(),
		cqp.SystemProcessFee,
		@ApplyExpiryDate
	FROM dbo.ClientQuotationProduct cqp WITH(NOLOCK)
	WHERE cqp.Id = @MasterClientQuotationProductId

	SELECT @ChildQuotaionProductId = SCOPE_IDENTITY()

	--母是Super, 需要在子产品里看有没有相同Brand的

	DECLARE @Sequence INT = NULL;
	IF (@masterSubType = 8 OR @masterSubType = 10)
	BEGIN
		SELECT @Sequence = cqpc.Sequence
			FROM dbo.ClientQuotationProduct cqp WITH(NOLOCK)
			JOIN dbo.ClientQuotationProductCombo cqpc WITH(NOLOCK) ON cqpc.ClientQuotationProductId = cqp.Id
			JOIN dbo.ClientQuotationProduct childCqp WITH(NOLOCK) ON childCqp.Id = cqpc.ChildClientQuotationProductId
			JOIN dbo.ProductVersion childPV WITH(NOLOCK) ON childPV.Id = childCqp.ProductVersionId
			JOIN dbo.Product childP WITH(NOLOCK) ON childP.Id = childPV.ProductId
			WHERE cqp.Id = @MasterClientQuotationProductId AND childP.BrandId = @childBrandId
	END

	IF @Sequence IS NOT NULL
	BEGIN
		INSERT INTO dbo.ClientQuotationProductCombo(
			ClientQuotationProductId,
			ProductComboSetId,
			BusinessModelId,
			ExpirySchemeId,
			ExpirationDate,
			ChildClientQuotationProductId,
			[Sequence]
			)
		VALUES (
			@MasterClientQuotationProductId,
			@ChildProductComboSetId,
			@ChildBusinessModelId,
			@ApplyExpiryId,
			@ApplyExpiryDate,
			@ChildQuotaionProductId,
			@Sequence
			)
	END
	ELSE
	BEGIN
		INSERT INTO dbo.ClientQuotationProductCombo(
			ClientQuotationProductId,
			ProductComboSetId,
			BusinessModelId,
			ExpirySchemeId,
			ExpirationDate,
			ChildClientQuotationProductId,
			[Sequence]
			)
		SELECT top (1) 
			@MasterClientQuotationProductId,
			@ChildProductComboSetId,
			@ChildBusinessModelId,
			@ApplyExpiryId,
			@ApplyExpiryDate,
			@ChildQuotaionProductId,
			cqpc.[Sequence]+1 
		FROM dbo.ClientQuotationProductCombo cqpc WITH(NOLOCK)
		WHERE cqpc.ClientQuotationProductId = @MasterClientQuotationProductId
		ORDER BY cqpc.[Sequence] DESC
	END

	INSERT  INTO dbo.ClientQuotationPricing(
		ClientQuotationProductId ,
		TransactionTypeId ,
		InvoiceClient ,
		ValueBasedInvoiceClient ,
		ValidityFrom ,
		ValidityEnd)
	SELECT DISTINCT
		cqpc.ChildClientQuotationProductId ,
		pricing.TransactionTypeId ,
		pricing.InvoiceClient ,
		pricing.ValueBasedInvoiceClient ,
		pricing.ValidityFrom ,
		pricing.ValidityEnd
	FROM dbo.ClientQuotationProduct cqp WITH(NOLOCK)
	JOIN dbo.ClientQuotationProductCombo cqpc WITH(NOLOCK) ON cqpc.ClientQuotationProductId = cqp.Id
	JOIN dbo.ClientQuotationPricing pricing WITH(NOLOCK) ON pricing.ClientQuotationProductId = cqp.Id
	WHERE cqp.Id = @MasterClientQuotationProductId AND cqpc.ChildClientQuotationProductId = @ChildQuotaionProductId

	INSERT INTO dbo.ClientQuotationProductServiceFeeTriggerTime(
		ClientQuotationProductId ,
        ServiceFeeTriggerTimeId ,
        SoldPrice ,
        SoldPriceWithTax ,
        ValidityFrom ,
        ValidityEnd ,
        Status ,
        CreatedBy ,
        CreatedOn ,
        ApprovedBy ,
        ApprovedOn)
    SELECT DISTINCT
            cqpc.ChildClientQuotationProductId,
            cqpsft.ServiceFeeTriggerTimeId ,
            cqpsft.SoldPrice ,
            cqpsft.SoldPriceWithTax ,
            cqpsft.ValidityFrom ,
            cqpsft.ValidityEnd ,
            cqpsft.Status ,
            cqpsft.CreatedBy ,
            cqpsft.CreatedOn ,
            cqpsft.ApprovedBy ,
            cqpsft.ApprovedOn
    FROM    dbo.ClientQuotationProduct cqp WITH(NOLOCK)
            JOIN dbo.ClientQuotationProductCombo cqpc WITH(NOLOCK) ON cqpc.ClientQuotationProductId = cqp.Id
            JOIN dbo.ClientQuotationProductServiceFeeTriggerTime cqpsft WITH(NOLOCK) ON cqpsft.ClientQuotationProductId = cqp.Id
    WHERE   cqp.Id = @MasterClientQuotationProductId AND cqpc.ChildClientQuotationProductId = @ChildQuotaionProductId

	INSERT INTO dbo.ClientQuotationProductSoldPrice(
		ClientQuotationProductId ,
		SoldPriceWithoutTax ,
		SoldPriceWithTax ,
		ValueBasedSoldPriceWithoutTax ,
		ValueBasedSoldPriceWithTax ,
		ValidityFrom ,
		ValidityEnd ,
		Status ,
		CreatedBy ,
		CreatedOn ,
		ApprovedBy ,
		ApprovedOn ,
		SoldPricePercentage ,
		FaceValueRangeFrom ,
		FaceValueRangeTo)
	--Super Voucher 母产品的ValueBasedSoldPriceWithTax / FaceValueWithTax 得到一个比值 使用这个比值得到子产品的soldPrice
	SELECT DISTINCT
		cqpc.ChildClientQuotationProductId ,
		CASE 
			WHEN childP.ProductType = 1 THEN
				CASE 
					WHEN masterP.ProductType = 2 AND (masterP.ProductSubType = 6 OR masterP.ProductSubType = 8)
						THEN CONVERT(numeric(15,4), childPPPB.FaceValue * cqpPrice.ValueBasedSoldPriceWithTax / masterPPVB.FaceValueWithTax)
					ELSE CONVERT(numeric(15,4),cqpPrice.SoldPriceWithoutTax / childPPPB.Balance)
				END
			ELSE NULL
        END,
		CASE 
			WHEN childP.ProductType = 1 THEN
				CASE 
					WHEN masterP.ProductType = 2 AND (masterP.ProductSubType = 6 OR masterP.ProductSubType = 8)
						THEN CONVERT(numeric(15,4), childPPPB.FaceValueWithTax * cqpPrice.ValueBasedSoldPriceWithTax / masterPPVB.FaceValueWithTax)
					ELSE CONVERT(numeric(15,4),cqpPrice.SoldPriceWithTax / childPPPB.Balance)
				END
			ELSE NULL
        END,
        CASE 
			WHEN childP.ProductType = 2 THEN
				CASE 
					WHEN masterP.ProductType = 2 AND (masterP.ProductSubType = 6 OR masterP.ProductSubType = 8)
						THEN CONVERT(numeric(15,4), childPPVB.FaceValue * cqpPrice.ValueBasedSoldPriceWithTax / masterPPVB.FaceValueWithTax)
					ELSE cqpPrice.SoldPriceWithoutTax
				END
			ELSE NULL
        END,
        CASE 
			WHEN childP.ProductType = 2 THEN
				CASE 
					WHEN masterP.ProductType = 2 AND (masterP.ProductSubType = 6 OR masterP.ProductSubType = 8)
						THEN CONVERT(numeric(15,4), childPPVB.FaceValueWithTax * cqpPrice.ValueBasedSoldPriceWithTax / masterPPVB.FaceValueWithTax)
					ELSE cqpPrice.SoldPriceWithTax
				END
			ELSE NULL
        END,
        cqpPrice.ValidityFrom ,
        cqpPrice.ValidityEnd ,
        cqpPrice.Status ,
        cqpPrice.CreatedBy ,
        cqpPrice.CreatedOn ,
        cqpPrice.ApprovedBy ,
        cqpPrice.ApprovedOn ,
		CASE 
			WHEN childP.ProductSubType = 4 THEN
				CASE 
					WHEN masterP.ProductType = 2 AND (masterP.ProductSubType = 6 OR masterP.ProductSubType = 8)
						THEN CONVERT(decimal(10,6), cqpPrice.SoldPriceWithTax / 100)
					ELSE NULL
				END
			ELSE NULL
		END,
		CASE 
			WHEN childP.ProductSubType = 4 THEN
				CASE 
					WHEN masterP.ProductType = 2 AND (masterP.ProductSubType = 6 OR masterP.ProductSubType = 8)
						THEN 1
					ELSE NULL
				END
			ELSE NULL
		END,
		CASE 
			WHEN childP.ProductSubType = 4 THEN
				CASE 
					WHEN masterP.ProductType = 2 AND (masterP.ProductSubType = 6 OR masterP.ProductSubType = 8)
						THEN CONVERT(int, masterPPVB.FaceValueWithTax / 100)
					ELSE NULL
				END
			ELSE NULL
		END
    FROM dbo.ClientQuotationProduct cqp WITH(NOLOCK)
    JOIN dbo.ClientQuotationProductCombo cqpc WITH(NOLOCK) ON cqpc.ClientQuotationProductId = cqp.Id
    JOIN dbo.ClientQuotationProductSoldPrice cqpPrice WITH(NOLOCK) ON cqpPrice.ClientQuotationProductId = cqp.Id
    JOIN dbo.ClientQuotationProduct childCqp WITH(NOLOCK) ON childcqp.Id = cqpc.ChildClientQuotationProductId
	JOIN dbo.ProductVersion childPV WITH(NOLOCK) ON childPV.Id = childCqp.ProductVersionId
	JOIN dbo.Product childP WITH(NOLOCK) ON childP.Id = childPV.ProductId
	JOIN dbo.ProductVersion masterPV WITH(NOLOCK) ON masterPV.Id = cqp.ProductVersionId
	JOIN dbo.Product masterP WITH(NOLOCK) ON masterP.Id = masterPV.ProductId
	LEFT JOIN dbo.ProductPricingValueBased masterPPVB WITH(NOLOCK) ON masterPPVB.Id = masterPV.ProductPricingValueBasedId
	LEFT JOIN dbo.ProductPricingValueBased childPPVB WITH(NOLOCK) ON childPPVB.Id = childPV.ProductPricingValueBasedId
	LEFT JOIN dbo.ProductPricingProductBased childPPPB WITH(NOLOCK) ON childPPPB.Id = childPV.ProductPricingProductBasedId
    WHERE cqp.Id = @MasterClientQuotationProductId
		AND cqpc.ChildClientQuotationProductId = @ChildQuotaionProductId
END