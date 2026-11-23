
CREATE PROCEDURE [dbo].[spDeleteClientQuotationProduct]
    @ClientQuotationProductId INT ,
    @IsSuccess BIT OUTPUT
AS
    BEGIN
        BEGIN TRY 
            BEGIN  TRAN;
            DELETE  FROM ClientQuotationPricing
            WHERE   ClientQuotationProductId = @ClientQuotationProductId;

            DELETE  FROM ClientQuotationProductSoldPrice
            WHERE   ClientQuotationProductId = @ClientQuotationProductId;

            DELETE  FROM ClientQuotationProductSoldPriceHistory
            WHERE   ClientQuotationProductId = @ClientQuotationProductId;

            DELETE  FROM ClientQuotationProductServiceFeeTriggerTime
            WHERE   ClientQuotationProductId = @ClientQuotationProductId;

			DELETE dbo.ResellerPricing WHERE ClientQuotationProductId = @ClientQuotationProductId;

            DELETE  FROM ClientQuotationProduct
            WHERE   Id = @ClientQuotationProductId;
            COMMIT TRAN;
            SET @IsSuccess = 1;
        END TRY	
        BEGIN CATCH
            SET @IsSuccess = 0;
            ROLLBACK TRAN; 
        END CATCH;
    END;
