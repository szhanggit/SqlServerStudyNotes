
CREATE PROCEDURE dbo.spAddMerchantForProduct
    @ProductCode varchar(50)
	,@MerchantId int
	,@VoucherNumberRuleId int
	,@ErrorMessage NVARCHAR(4000) OUTPUT
	,@ErrorLine INT OUTPUT
AS  
BEGIN
SET NOCOUNT ON


	BEGIN TRAN

	BEGIN TRY

------------------------------------------------------------
		DECLARE @OldAcceptanceLoopId int;
		DECLARE @AcceptanceLoopId int;
		DECLARE @AcceptanceLoopMerchantId int;
		DECLARE @pvId int;
		DECLARE @MerchantCursor as CURSOR;
		DECLARE @ShopId int;
		DECLARE @ShopCursor as CURSOR;

		INSERT AcceptanceLoop DEFAULT VALUES;
		SELECT @AcceptanceLoopId = SCOPE_IDENTITY();

		update Product
		set VoucherNumberRuleId = @VoucherNumberRuleId
		where ProductCode = @ProductCode

		select @OldAcceptanceLoopId = AcceptanceLoopId from Product with(nolock) where ProductCode = @ProductCode;

		SELECT @pvID = pv.Id
		FROM Product p with(nolock)
		INNER JOIN ProductVersion pv with(nolock) on p.Id = pv.ProductId
		WHERE p.ProductCode = @ProductCode and pv.IsCurrentVersion = 1


		update Product
		set AcceptanceLoopId = @AcceptanceLoopId
		where ProductCode = @ProductCode;

		INSERT INTO ProductVersion(ProgramId,
			ProductId,
			ExternalProductCode,
			ProductName,
			[Description],
			Note,
			EmailTemplateVersionId,
			EmailTemplateTagValueId,
			SLMSTemplateVersionId,
			SLMSTemplateTagValueId,
			IsMultiBrand,
			AcceptanceLoopId,
			ProductPricingProductBasedId,
			ProductPricingValueBasedId,
			MinRedeemQuantity,
			MaxIssuingQuantity,
			ValidFrom,
			ValidTo,
			RedeemDateBlacklistId,
			ReverseLimitId,
			PreAuthorizationExpiryInterval,
			PreAuthorizationExpiryUnit,
			RedeemTimeRestrictionId,
			ProductExpirySchemeId,
			UseTimeControl,
			UseTimeControlInterval,
			MaxTotalRedeemAmountControl,
			MaxTotalRedeemAmountControlInterval,
			MaxSingleRedeemAmount,
			ExternalPropertyId,
			Modifier,
			[Version],
			VersionTime,
			IsCurrentVersion,
			APICacheHW,
			APICacheLW,
			BrandStory,
			MultipleSelectionType,
			ProductIssuerType,
			IssueMerchant,
			ProductEmailTemplateVersionId,
			ProductSLMSTemplateVersionId,
			PinCodeType,
			PinCodeLength,
			IsMasterProduct,
			ProductComboId,
			ProductTag,
			AddToWallet
		)
		SELECT pv.ProgramId,
			pv.ProductId,
			pv.ExternalProductCode,
			pv.ProductName,
			pv.[Description],
			pv.Note,
			pv.EmailTemplateVersionId,
			pv.EmailTemplateTagValueId,
			pv.SLMSTemplateVersionId,
			pv.SLMSTemplateTagValueId,
			pv.IsMultiBrand,
			@AcceptanceLoopId,
			pv.ProductPricingProductBasedId,
			pv.ProductPricingValueBasedId,
			pv.MinRedeemQuantity,
			pv.MaxIssuingQuantity,
			pv.ValidFrom,
			pv.ValidTo,
			pv.RedeemDateBlacklistId,
			pv.ReverseLimitId,
			pv.PreAuthorizationExpiryInterval,
			pv.PreAuthorizationExpiryUnit,
			pv.RedeemTimeRestrictionId,
			pv.ProductExpirySchemeId,
			pv.UseTimeControl,
			pv.UseTimeControlInterval,
			pv.MaxTotalRedeemAmountControl,
			pv.MaxTotalRedeemAmountControlInterval,
			pv.MaxSingleRedeemAmount,
			pv.ExternalPropertyId,
			'Support' as Modifier,
			pv.[Version] + 1,
			getdate(),
			pv.IsCurrentVersion,
			pv.APICacheHW,
			pv.APICacheLW,
			pv.BrandStory,
			pv.MultipleSelectionType,
			pv.ProductIssuerType,
			pv.IssueMerchant,
			pv.ProductEmailTemplateVersionId,
			pv.ProductSLMSTemplateVersionId,
			pv.PinCodeType,
			pv.PinCodeLength,
			pv.IsMasterProduct,
			pv.ProductComboId,
			pv.ProductTag,
			pv.AddToWallet 
		FROM Product p with(nolock)
		INNER JOIN ProductVersion pv with(nolock) on p.Id = pv.ProductId
		WHERE p.ProductCode = @ProductCode and pv.IsCurrentVersion = 1

		UPDATE pv
		SET pv.IsCurrentVersion = 0
		FROM Product p with(nolock)
		INNER JOIN ProductVersion pv with(nolock) on p.Id = pv.ProductId
		WHERE p.ProductCode = @ProductCode and pv.IsCurrentVersion = 1 and pv.Id = @pvID

		
		
		
		
		
		CREATE TABLE #MerchantTemp
		(
		MerchantId int NULL
		)
		insert into #MerchantTemp (MerchantId)
		select distinct m.Id from AcceptanceLoopMerchant alm with(nolock) 
		inner join AcceptanceLoopShop als with(nolock) on als.AcceptanceLoopMerchantId = alm.Id
		inner join Merchant m with(nolock) on alm.MerchantId = m.Id
		where alm.AcceptanceLoopId = @OldAcceptanceLoopId

		insert into #MerchantTemp (MerchantId) values (@MerchantId);

		SET @MerchantCursor = CURSOR FOR
		select MerchantId from #MerchantTemp with(nolock)


		OPEN @MerchantCursor;
		FETCH NEXT FROM @MerchantCursor INTO @MerchantId;
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-------------

			insert into AcceptanceLoopMerchant (AcceptanceLoopId, MerchantId) values (@AcceptanceLoopId, @MerchantId);
			select @AcceptanceLoopMerchantId = SCOPE_IDENTITY(); 

			SET @ShopCursor = CURSOR FOR
			select s.Id from Merchant m with(nolock) 
			inner join Shop s with(nolock) on s.MerchantId = m.Id
			where m.Id = @MerchantId AND s.[Status] = 1;


			OPEN @ShopCursor;
			FETCH NEXT FROM @ShopCursor INTO @ShopId;
			WHILE @@FETCH_STATUS = 0
			BEGIN
				-------------

				insert into AcceptanceLoopShop (AcceptanceLoopMerchantId, ShopId) values (@AcceptanceLoopMerchantId, @ShopId);

				
				set @ShopId = -1;
			
				----------------
		        FETCH NEXT FROM @ShopCursor INTO @ShopId;
		        END



			set @AcceptanceLoopMerchantId = -1;
		        set @MerchantId = -1;
		        ----------------
		FETCH NEXT FROM @MerchantCursor INTO @MerchantId;
		END

		drop table #MerchantTemp;		
		
		
------------------------------------------------------------
	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorLine = ERROR_LINE();	
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;
	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
		
END		
