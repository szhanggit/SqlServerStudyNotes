-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[spClientQuotationProductApprove]
	@QuotationNumber VARCHAR(50),
	@ProductCode VARCHAR(50),
	@UserName VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;
		
	DECLARE @ClientQuotationId  INT;
	DECLARE @CurrentDate  DATETIME;

	SET @CurrentDate = FORMAT(GETDATE(),'yyyy-MM-dd');
	SELECT @ClientQuotationId = Id FROM [dbo].[ClientQuotation] WHERE QuotationNumber = @QuotationNumber

	BEGIN TRY	
		BEGIN TRANSACTION

			-- Change quotation product status.	
			UPDATE T1
			SET T1.[Status] = 32
				,[ApprovedBy] = @UserName
				,[ApprovedOn] = GETDATE()
			FROM [dbo].[ClientQuotationProduct] AS T1
				INNER JOIN [dbo].[ClientQuotation] AS T2 ON T1.ClientQuotationId = T2.Id
				INNER JOIN [dbo].[ProductVersion] AS T3 ON T1.ProductVersionId = T3.Id
				INNER JOIN [dbo].[Product] AS T4 ON T3.ProductId = T4.Id
			WHERE T2.QuotationNumber = @QuotationNumber
				AND T4.ProductCode = @ProductCode
				AND T1.[Status] != 32
			
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
			INNER JOIN [dbo].[ProductVersion] AS T4 ON T2.ProductVersionId = T4.Id
			INNER JOIN [dbo].[Product] AS T5 ON T4.ProductId = T5.Id
			WHERE T3.QuotationNumber = @QuotationNumber
			AND T5.ProductCode = @ProductCode
			AND T1.[Status] = 1
			
			/*If current is later than validity from,then set validity fome to now.*/
			UPDATE T1
			SET T1.[ValidityFrom] = @CurrentDate
			FROM [dbo].[ClientQuotationProductSoldPrice] AS T1
			INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
			INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
			INNER JOIN [dbo].[ProductVersion] AS T4 ON T2.ProductVersionId = T4.Id
			INNER JOIN [dbo].[Product] AS T5 ON T4.ProductId = T5.Id
			WHERE T3.QuotationNumber = @QuotationNumber
			AND T5.ProductCode = @ProductCode
			AND T1.[Status] = 1	
			AND T1.[ValidityFrom] < @CurrentDate
			
			/*set previous validity end to the day before today */
			UPDATE T1
			SET T1.[ValidityEnd] = DATEADD(SS,-1,T4.[ValidityFrom])
			FROM [dbo].[ClientQuotationProductSoldPrice] AS T1
			INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
			INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
			INNER JOIN [dbo].[ClientQuotationProductSoldPrice] AS T4 ON T4.ClientQuotationProductId = T1.ClientQuotationProductId
			INNER JOIN [dbo].[ProductVersion] AS T5 ON T2.ProductVersionId = T5.Id
			INNER JOIN [dbo].[Product] AS T6 ON T5.ProductId = T6.Id
			WHERE T3.QuotationNumber = @QuotationNumber
			AND T6.ProductCode = @ProductCode
			AND T1.[Status] = 2
			AND T1.[ValidityEnd] = '3999-01-01 00:00:00.000'
			AND T4.[Status] = 1
			
			/* set ClientQuotationPricing previous validity end to the day before today */
			UPDATE T1
			SET [ValidityEnd] = DATEADD(SS,-1,T4.[ValidityFrom])
			FROM [dbo].[ClientQuotationPricing] AS T1
			INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
			INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
			INNER JOIN [dbo].[ClientQuotationProductSoldPrice] AS T4 ON T4.ClientQuotationProductId = T1.ClientQuotationProductId
			INNER JOIN [dbo].[ProductVersion] AS T5 ON T2.ProductVersionId = T5.Id
			INNER JOIN [dbo].[Product] AS T6 ON T5.ProductId = T6.Id
			WHERE T3.QuotationNumber = @QuotationNumber
			AND T6.ProductCode = @ProductCode
			AND T1.[ValidityEnd] = '3999-01-01 00:00:00.000'
			AND T4.[ValidityEnd] = '3999-01-01 00:00:00.000'
			AND T4.[Status] = 1
			
			/* Add data into ClientQuotationPricing */
			INSERT INTO [dbo].[ClientQuotationPricing]
				([ClientQuotationProductId]
				,[TransactionTypeId]
				,[InvoiceClient]
				,[ValueBasedInvoiceClient]
				,[ValidityFrom]
				,[ValidityEnd])
			SELECT DISTINCT
				T2.Id AS [ClientQuotationProductId]
				,T1.[TransactionTypeId]
				,ISNULL(T4.SoldPriceWithoutTax,0)* T5.[FaceValueCoefficient]
				,ISNULL(T4.ValueBasedSoldPriceWithoutTax,0)
				,T4.[ValidityFrom]
				,T4.[ValidityEnd]
			FROM [dbo].[ClientQuotationPricing] AS T1
			INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
			INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
			INNER JOIN [dbo].[ClientQuotationProductSoldPrice] AS T4 ON T4.ClientQuotationProductId = T1.ClientQuotationProductId
			INNER JOIN [dbo].[BusinessModelTransactionType] AS T5 ON T5.[TransactionTypeId] = T1.[TransactionTypeId] AND T5.[BusinessModelId] = T3.BusinessModelId
			INNER JOIN [dbo].[ProductVersion] AS T6 ON T2.ProductVersionId = T6.Id
			INNER JOIN [dbo].[Product] AS T7 ON T6.ProductId = T7.Id
			WHERE T3.QuotationNumber = @QuotationNumber
			AND T7.ProductCode = @ProductCode
			AND T4.[Status] = 1
			
			-- Approve Reseller Sold Price
			UPDATE T1 SET T1.[Status] = 2
			FROM [dbo].[ResellerPricing] AS T1
			INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
			INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
			INNER JOIN [dbo].[ProductVersion] AS T4 ON T2.ProductVersionId = T4.Id
			INNER JOIN [dbo].[Product] AS T5 ON T4.ProductId = T5.Id
			WHERE T3.QuotationNumber = @QuotationNumber
			AND T5.ProductCode = @ProductCode
			AND T1.[Status] = 1

			-- Approve product sold price
			UPDATE T1
			SET T1.[Status] = 2
				,[ApprovedBy] = @UserName 
				,[ApprovedOn] = GETDATE()
			FROM [dbo].[ClientQuotationProductSoldPrice] AS T1
			INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
			INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
			INNER JOIN [dbo].[ProductVersion] AS T4 ON T2.ProductVersionId = T4.Id
			INNER JOIN [dbo].[Product] AS T5 ON T4.ProductId = T5.Id
			WHERE T3.QuotationNumber = @QuotationNumber
			AND T5.ProductCode = @ProductCode
			AND T1.[Status] = 1
			
			/*If current is later than validity from,then set validity fome to now.*/
			UPDATE T1
			SET T1.[ValidityFrom] = @CurrentDate
			FROM [dbo].[ClientQuotationProductServiceFeeTriggerTime] AS T1
			INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
			INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
			INNER JOIN [dbo].[ProductVersion] AS T4 ON T2.ProductVersionId = T4.Id
			INNER JOIN [dbo].[Product] AS T5 ON T4.ProductId = T5.Id
			WHERE T3.QuotationNumber = @QuotationNumber
			AND T5.ProductCode = @ProductCode
			AND T1.[Status] = 1 
			AND T1.[ValidityFrom] < @CurrentDate
			
			/*set previous validity end to the day before today */
			UPDATE T1
			SET T1.[ValidityEnd] = DATEADD(SS,-1,T4.[ValidityFrom])
			FROM [dbo].[ClientQuotationProductServiceFeeTriggerTime] AS T1
			INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
			INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
			INNER JOIN [dbo].[ClientQuotationProductServiceFeeTriggerTime] AS T4 ON T1.ClientQuotationProductId = T4.ClientQuotationProductId AND T1.[ServiceFeeTriggerTimeId] = T4.[ServiceFeeTriggerTimeId]
			INNER JOIN [dbo].[ProductVersion] AS T5 ON T2.ProductVersionId = T5.Id
			INNER JOIN [dbo].[Product] AS T6 ON T5.ProductId = T6.Id
			WHERE T3.QuotationNumber = @QuotationNumber
			AND T6.ProductCode = @ProductCode
			AND T1.[Status] = 2
			AND T1.[ValidityEnd] = '3999-01-01 00:00:00.000'
			AND T4.[Status] = 1
			
			-- Approve service fee sold price
			UPDATE T1
			SET T1.[Status] = 2
				,[ApprovedBy] = @UserName
				,[ApprovedOn] = GETDATE()
			FROM [dbo].[ClientQuotationProductServiceFeeTriggerTime] AS T1
			INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
			INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
			INNER JOIN [dbo].[ProductVersion] AS T4 ON T2.ProductVersionId = T4.Id
			INNER JOIN [dbo].[Product] AS T5 ON T4.ProductId = T5.Id
			WHERE T3.QuotationNumber = @QuotationNumber
			AND T5.ProductCode = @ProductCode
			AND T1.[Status] = 1
			
			DECLARE @ProductType TINYINT
			DECLARE @SoldPriceWithTax NUMERIC(15,4)
			DECLARE @FaceValueWithTax INT
			DECLARE @ValidityFrom DATETIME
			DECLARE @ValidityEnd DATETIME
			DECLARE @OrderLineTrustAccountId INT
			DECLARE @OrderLineId INT
			
			SELECT TOP 1 @ProductType = P.ProductType, @SoldPriceWithTax = CQPSP.SoldPriceWithTax, @FaceValueWithTax = PPV.FaceValueWithTax, @ValidityFrom = CQPSP.ValidityFrom, @ValidityEnd = CQPSP.ValidityEnd
			FROM ClientQuotationProductSoldPrice CQPSP
			INNER JOIN ClientQuotationProduct CQP ON CQPSP.ClientQuotationProductId = CQP.Id
			INNER JOIN ClientQuotation CQ ON CQP.ClientQuotationId = CQ.Id
			INNER JOIN ProductVersion PV ON CQP.ProductVersionId = PV.Id
			INNER JOIN Product P ON PV.ProductId = P.Id
			LEFT OUTER JOIN ProductPricingValueBased PPV ON PV.ProductPricingValueBasedId = PPV.Id
			WHERE CQ.QuotationNumber = @QuotationNumber AND P.ProductCode = @ProductCode
			ORDER BY CQPSP.Id DESC
			
			DECLARE C CURSOR FOR
			SELECT MAX(OLTA.Id) Id, OLTA.OrderLineId
			FROM ClientQuotation CQ
			INNER JOIN ClientQuotationProduct CQP ON CQ.Id = CQP.ClientQuotationId
			INNER JOIN ProductVersion PV ON CQP.ProductVersionId = PV.Id
			INNER JOIN Product P ON PV.ProductId = P.Id
			INNER JOIN OrderLine OL ON CQP.Id = OL.ClientQuotationProductId
			INNER JOIN OrderLineTrustAccount OLTA ON OL.Id = OLTA.OrderLineId
			WHERE CQ.QuotationNumber = @QuotationNumber AND P.ProductCode = @ProductCode
			AND OLTA.TrustAccountOption = 1 -- Default
			GROUP BY OLTA.OrderLineId
			
			OPEN C
			FETCH NEXT FROM C INTO @OrderLineTrustAccountId, @OrderLineId
			
			WHILE @@FETCH_STATUS = 0
			BEGIN
				UPDATE OrderLineTrustAccount SET ValidTo = DATEADD(SS, -1, @ValidityFrom) WHERE Id = @OrderLineTrustAccountId
				
				INSERT INTO OrderLineTrustAccount (OrderLineId, TrustAccountId, TrustAccountOption, TrustAccountBatchNo, Amount, ExpiryPolicyId, ExpiryDate, ValidFrom, ValidTo)
				SELECT OrderLineId, TrustAccountId, TrustAccountOption, TrustAccountBatchNo, 
				CASE @ProductType WHEN 1 THEN @SoldPriceWithTax WHEN 2 THEN @FaceValueWithTax END,
				ExpiryPolicyId, ExpiryDate, @ValidityFrom, @ValidityEnd
				FROM OrderLineTrustAccount
				WHERE Id = @OrderLineTrustAccountId
				
				INSERT dbo.OrderLineTrustAccountHistory(
					OrderLineId, NeedTrustAccount, CreateTime, Creator, OrderLineTrustAccountId, 
					TrustAccountId, TrustAccountOption, TrustAccountBatchNo, Amount, ExpiryPolicyId, 
					ExpiryDate, ValidFrom, ValidTo)
				SELECT TOP (1) OrderLineId, 1, GETDATE(), 'SP', Id, 
					TrustAccountId, TrustAccountOption, TrustAccountBatchNo, Amount, ExpiryPolicyId, 
					ExpiryDate, ValidFrom, ValidTo 
				FROM dbo.OrderLineTrustAccount WHERE OrderLineId = @OrderLineId ORDER BY Id DESC

				FETCH NEXT FROM C INTO @OrderLineTrustAccountId, @OrderLineId
			END
			
			CLOSE C
			DEALLOCATE C
			
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
			ROLLBACK TRANSACTION;
	END CATCH

END