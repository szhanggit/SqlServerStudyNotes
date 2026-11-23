-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[spChangeClientQuotationStatus]
	@QuotationNumber VARCHAR(50)
	,@Status INT
	,@UserName VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;
		
	DECLARE @ClientQuotationId  INT;

	SELECT @ClientQuotationId = Id FROM [dbo].[ClientQuotation] WHERE QuotationNumber = @QuotationNumber

	BEGIN TRY	
		BEGIN TRANSACTION
			
			-- Change quotation status.		
			UPDATE [dbo].[ClientQuotation]
			SET [Status] = @Status
			WHERE QuotationNumber = @QuotationNumber

			-- Change quotation product status.	
			UPDATE T1
			SET T1.[Status] = @Status
			FROM [dbo].[ClientQuotationProduct] AS T1
				INNER JOIN [dbo].[ClientQuotation] AS T2 ON T1.ClientQuotationId = T2.Id
			WHERE T2.QuotationNumber = @QuotationNumber

			-- Approve price.
			IF(@Status = 32)
				BEGIN

					-- Add quotation product sold price history
					INSERT INTO [dbo].[ClientQuotationProductSoldPriceHistory](
						ClientQuotationProductId	
						, OldSoldPrice
						, NewSoldPrice
						, ApprovedBy
						, ApprovedOn
						, NewSoldPriceWithTax)
					SELECT T2.Id
						, 0
						, T1.SoldPriceWithoutTax
						, @UserName
						, GETDATE()
						, T1.SoldPriceWithTax
					FROM [dbo].[ClientQuotationProductSoldPrice] AS T1
					INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
					INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
					WHERE T3.QuotationNumber = @QuotationNumber
					AND T1.[Status] = 1

					-- Approve Reseller Sold Price
					UPDATE T1 SET T1.[Status] = 2
					FROM [dbo].[ResellerPricing] AS T1
					INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
					INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
					WHERE T3.QuotationNumber = @QuotationNumber
					AND T1.[Status] = 1

					-- Approve product sold price
					UPDATE T1
					SET T1.[Status] = 2
					FROM [dbo].[ClientQuotationProductSoldPrice] AS T1
					INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
					INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
					WHERE T3.QuotationNumber = @QuotationNumber
					AND T1.[Status] = 1

					-- Approve service fee sold price
					UPDATE T1
					SET T1.[Status] = 2
					FROM [dbo].[ClientQuotationProductServiceFeeTriggerTime] AS T1
					INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
					INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
					WHERE T3.QuotationNumber = @QuotationNumber
					AND T1.[Status] = 1

				END

			-- Add quotation status history
			INSERT INTO [dbo].[ClientQuotationStatusHistory]
					   ([ClientQuotationId]
					   ,[Operation]
					   ,[Operator]
					   ,[OperationTime])
				 VALUES
					   (@ClientQuotationId
					   ,CONVERT(NVARCHAR(50),@Status)
					   ,@UserName
					   ,GETDATE())

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
			ROLLBACK TRANSACTION;
	END CATCH		

END

