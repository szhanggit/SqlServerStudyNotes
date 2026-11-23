

CREATE function [dbo].[Pacy_F_GetIssueDiscount](
		@BusinessModelId TINYINT, --  dbo.ClientQuotation.businessModelId = dbo.BusinessModel.Id
		@FaceValue INT, --cent, dbo.ProductPricingProductBased.FaceValue (product base) / dbo.ProductPricingValueBased.FaceValue (value base)
		@FaceValueWithTax INT, --cent, dbo.ProductPricingProductBased.FaceValueWithTax (product base) / dbo.ProductPricingValueBased.FaceValueWithTax (value base)
		@SoldPrice NUMERIC(15, 4), --cent, dbo.ClientQuotationProductSoldPrice.SoldPriceWithoutTax (product base) / dbo.ProductPricingValueBased.ValueBasedSoldPriceWithoutTax (value base)
		@TranType SMALLINT, -- dbo.Transaction.TranType
		@TranAmount INT , -- dbo.Transaction.TranType
		@ProductIssuerType TINYINT,  --dbo.Product.ProductIssuerType / 0:Issuer Model; 2:Reseller Model; 3:White Label
		@ProductType TINYINT,  -- dbo.Product.ProductType / 1:product based, 2:Value based
		@MultipleSelectionType TINYINT  --dbo.Product.ProductType / 0:General; 1:Master; 2:Child
)
RETURNS NUMERIC(20,6)
AS
BEGIN

	DECLARE @ret AS NUMERIC(20,6)
	SELECT @ret = 0

	IF(@BusinessModelId in (1,2,3,4,8)) -- Prepaid/Postpaid
		BEGIN
			IF(@MultipleSelectionType = 2)
				BEGIN
					SET @ret = 0;
				END
			ELSE IF (@ProductType = 1)
				BEGIN
					IF(@TranType = 401)
						SET @ret = (@SoldPrice - @FaceValue*1.000000/100) * @TranAmount
					IF(@TranType = 501) 
						SET @ret = (@SoldPrice - @FaceValue*1.000000/100) * @TranAmount * -1
					IF(@TranType in (404, 405)) 
						SET @ret = (@SoldPrice - @FaceValue*1.000000/100) * @TranAmount * -1
					IF(@TranType = 503)
						SET @ret = (@SoldPrice - @FaceValue*1.000000/100) * @TranAmount
				END
			ELSE IF (@ProductType = 2)
				BEGIN
					IF(@FaceValueWithTax = 0)
						BEGIN
							SET @ret = 0;
						END
					ELSE
						BEGIN
							IF(@TranType = 401)
								SET @ret = @SoldPrice - @FaceValue*(@TranAmount/@FaceValueWithTax)*1.000000/100
							IF(@TranType = 501) 
								SET @ret = (@SoldPrice - @FaceValue*(@TranAmount/@FaceValueWithTax)*1.000000/100) * -1
							IF(@TranType in (404, 405)) 
								SET @ret = (@SoldPrice - @FaceValue*(@TranAmount/@FaceValueWithTax)*1.000000/100) * -1
							IF(@TranType in (403)) 
								SET @ret = (@SoldPrice - @FaceValue*(@TranAmount/@FaceValueWithTax)*1.000000/100) * -1
						END
				END

		END
	
	RETURN ISNULL(@ret,0)

END
