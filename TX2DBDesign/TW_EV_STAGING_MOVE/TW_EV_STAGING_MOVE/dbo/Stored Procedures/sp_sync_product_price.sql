
CREATE PROCEDURE [dbo].[sp_sync_product_price]
@RunId varchar(50)  
AS
BEGIN
	UPDATE TXCProductPriceSync SET
		SellingPricePostpaid = SellingPricePrepaid,
		SellingPricePostpaidWithTax = SellingPricePrepaidWithTax,
		CustomerFeePrepaidWithTax = SellingPricePrepaidWithTax * 10000 / FaceValueWithTax,
		CustomerFeePrepaid = SellingPricePrepaidWithTax * 10000 / FaceValueWithTax,
		CustomerFeePostpaidWithTax = SellingPricePrepaidWithTax * 10000 / FaceValueWithTax,
		CustomerFeePostpaid = SellingPricePrepaidWithTax * 10000 / FaceValueWithTax
	FROM TXCProductSync s
	WHERE TXCProductPriceSync.RunId = s.RunId AND TXCProductPriceSync.TXCProductPriceId = S.TXCProductPriceId
	AND S.ProductSubType IN (2, 8)
	AND S.RunId = @RunId
	
	DECLARE @TXCProductPriceId INT
	DECLARE @ProductVersionId INT
	DECLARE @ProductSubType INT
	DECLARE @TX2ProductPricingProductBasedId INT
	DECLARE @TX2ProductPricingValueBasedId INT
	
	BEGIN TRAN
	BEGIN TRY
		DECLARE C CURSOR FOR
		SELECT DISTINCT TXCProductPriceId, ProductVersionId, ProductSubType FROM TXCProductSync WHERE Runid = @RunId AND TXCProductPriceId IS NOT NULL
		
		OPEN C;
		FETCH NEXT FROM C INTO @TXCProductPriceId, @ProductVersionId, @ProductSubType
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @TX2ProductPricingProductBasedId = NULL
			SET @TX2ProductPricingValueBasedId = NULL
			
			IF @ProductSubType IN (1, 3, 5) -- Product-Based / Smart Booklet / Smart Choice Voucher
			BEGIN
				INSERT INTO ProductPricingProductBased (FaceValue, SellingPricePrepaid, SellingPricePostpaid, Cost, FaceValueWithTax, SellingPricePrepaidWithTax, SellingPricePostpaidWithTax, CostWithTax, Balance)
				SELECT DISTINCT FaceValue, SellingPricePrepaid, SellingPricePostpaid, Cost, FaceValueWithTax, SellingPricePrepaidWithTax, SellingPricePostpaidWithTax, CostWithTax, ISNULL(Balance, 1)
				FROM TXCProductPriceSync
				WHERE RunId = @RunId AND TXCProductPriceId = @TXCProductPriceId
				
				SET @TX2ProductPricingProductBasedId = SCOPE_IDENTITY()
			END
			
			IF @ProductSubType IN (2, 8) -- Value-Based / Super Voucher
			BEGIN
				INSERT INTO ProductPricingValueBased (FaceValue, CustomerFeePrepaid, CustomerFeePostpaid, MerchantFee, FaceValueWithTax, SellingPricePrepaid, SellingPricePrepaidWithTax, CustomerFeePrepaidWithTax, SellingPricePostpaid, SellingPricePostpaidWithTax, CustomerFeePostpaidWithTax, MerchantFeeWithTax)
				SELECT DISTINCT FaceValue, CustomerFeePrepaid, CustomerFeePostpaid, MerchantFee, FaceValueWithTax, SellingPricePrepaid, SellingPricePrepaidWithTax, CustomerFeePrepaidWithTax, SellingPricePostpaid, SellingPricePostpaidWithTax, CustomerFeePostpaidWithTax, MerchantFeeWithTax
				FROM TXCProductPriceSync
				WHERE RunId = @RunId AND TXCProductPriceId = @TXCProductPriceId
				
				SET @TX2ProductPricingValueBasedId = SCOPE_IDENTITY()
			END
			
			UPDATE TXCProductSync SET ProductPricingProductBasedId = @TX2ProductPricingProductBasedId, ProductPricingValueBasedId = @TX2ProductPricingValueBasedId
			WHERE RunId = @RunId AND TXCProductPriceId = @TXCProductPriceId
			
			FETCH NEXT FROM C INTO @TXCProductPriceId, @ProductVersionId, @ProductSubType
		END
		
		CLOSE C
		DEALLOCATE C
		
		COMMIT TRAN;
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		THROW;
	END CATCH
END
