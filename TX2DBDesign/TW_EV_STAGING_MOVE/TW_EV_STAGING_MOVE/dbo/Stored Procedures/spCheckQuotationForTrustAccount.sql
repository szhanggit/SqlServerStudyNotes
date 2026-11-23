CREATE PROC spCheckQuotationForTrustAccount @QuotationId INT
AS
BEGIN
	SET NOCOUNT ON;

	--BusinessType为B2E-Direct B2B2C
	--BusinessModel为Prepaid Prepaid-Refundable Prepaid-Extendable Post-paid-Redemption Employee-welfare Internal-Customers
	--BusinessModel为Prepaid-for-Merchant-self 且 SubBusinessModel为Merchant self-use ( required escrow)
	--满足以上条件预设为true

	DECLARE @type BIT = 0;
	DECLARE @model1 BIT = 0;
	DECLARE @model2 BIT = 0;
	DECLARE @subModel BIT = 0;

	SELECT @type = IIF(r1.Id IS NULL, 0, 1),
		   @model1 = IIF(r2.Id IS NULL, 0, 1),
		   @model2 = IIF(r3.Id IS NULL, 0, 1),
		   @subModel = IIF(r4.Id IS NULL, 0, 1)
	FROM dbo.ClientQuotation cq
		LEFT JOIN dbo.TrustAccountReference r1 ON r1.ReferType = 1 AND cq.BusinessTypeId = r1.ReferId
		LEFT JOIN dbo.TrustAccountReference r2 ON r2.ReferType = 2 AND cq.BusinessModelId = r2.ReferId
		LEFT JOIN dbo.TrustAccountReference r3 ON r3.ReferType = 3 AND cq.BusinessModelId = r3.ReferId
		LEFT JOIN dbo.TrustAccountReference r4 ON r4.ReferType = 4 AND cq.SubBusinessModelId = r4.ReferId
	WHERE cq.Id = @QuotationId;

	DECLARE @result BIT = 0;
	IF @type = 1 
	BEGIN
		IF @model1 = 1
			SET @result = 1;
		ELSE IF @model2 = 1 AND @subModel = 1
			SET @result = 1;
	END

	SELECT @result
END