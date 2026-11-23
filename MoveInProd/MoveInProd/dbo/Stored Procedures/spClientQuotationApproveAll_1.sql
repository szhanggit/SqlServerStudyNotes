CREATE PROCEDURE [dbo].[spClientQuotationApproveAll]
	@QuotationNumber VARCHAR(50),
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
	
	SELECT P.ProductCode, cqpsp.Id AS soldId
	INTO #ProductTemp
	FROM ClientQuotation CQ
	INNER JOIN ClientQuotationProduct CQP ON CQ.Id = CQP.ClientQuotationId
	INNER JOIN ProductVersion PV ON CQP.ProductVersionId = PV.Id
	INNER JOIN Product P ON PV.ProductId = P.Id
	LEFT JOIN ClientQuotationProductSoldPrice cqpsp ON cqpsp.ClientQuotationProductId = CQP.Id AND cqpsp.Status = 1
	WHERE CQ.Id = @ClientQuotationId
	
	BEGIN TRY
		BEGIN TRANSACTION
			
			-- Change quotation product status.
			UPDATE T1
			SET T1.[Status] = 32
				,[ApprovedBy] = @UserName
				,[ApprovedOn] = GETDATE()
			FROM [dbo].[ClientQuotationProduct] AS T1
				INNER JOIN [dbo].[ClientQuotation] AS T2 ON T1.ClientQuotationId = T2.Id
			WHERE T2.QuotationNumber = @QuotationNumber
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
				, ISNULL(T1.SoldPriceWithoutTax, 0) -- when null, means dynamic face value
				, @UserName
				, GETDATE()
				, T1.SoldPriceWithTax
			FROM [dbo].[ClientQuotationProductSoldPrice] AS T1
			INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
			INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
			WHERE T3.QuotationNumber = @QuotationNumber
			AND T1.[Status] = 1
			
			/*If current is later than validity from,then set validity fome to now.*/
			UPDATE T1
			SET T1.[ValidityFrom] = @CurrentDate
			FROM [dbo].[ClientQuotationProductSoldPrice] AS T1
			INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
			INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
			INNER JOIN [dbo].[ClientQuotationProductSoldPrice] AS T4 ON T4.ClientQuotationProductId = T1.ClientQuotationProductId
			WHERE T3.QuotationNumber = @QuotationNumber
			AND T1.[Status] = 1	
			AND T1.[ValidityFrom] < @CurrentDate
			AND T4.[Status] = 2
			
			/*set previous validity end to the day before today */
			UPDATE T1
			SET T1.[ValidityEnd] = DATEADD(SS,-1,T4.[ValidityFrom])
			FROM [dbo].[ClientQuotationProductSoldPrice] AS T1
			INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
			INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
			INNER JOIN [dbo].[ClientQuotationProductSoldPrice] AS T4 ON T4.ClientQuotationProductId = T1.ClientQuotationProductId
			WHERE T3.QuotationNumber = @QuotationNumber
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
			WHERE T3.QuotationNumber = @QuotationNumber
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
			WHERE T3.QuotationNumber = @QuotationNumber
			AND T4.[Status] = 1
			
			-- Approve product sold price
			UPDATE T1
			SET T1.[Status] = 2
				,[ApprovedBy] = @UserName 
				,[ApprovedOn] = GETDATE()
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

			/*If current is later than validity from,then set validity fome to now.*/
			UPDATE T1
			SET T1.[ValidityFrom] = @CurrentDate
			FROM [dbo].[ClientQuotationProductServiceFeeTriggerTime] AS T1
			INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
			INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
			WHERE T3.QuotationNumber = @QuotationNumber
			AND T1.[Status] = 1 
			AND T1.[ValidityFrom] < @CurrentDate
			
			/*set previous validity end to the day before today */
			UPDATE T1
			SET T1.[ValidityEnd] = DATEADD(SS,-1,T4.[ValidityFrom])
			FROM [dbo].[ClientQuotationProductServiceFeeTriggerTime] AS T1
			INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
			INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
			INNER JOIN [dbo].[ClientQuotationProductServiceFeeTriggerTime] AS T4 ON T1.ClientQuotationProductId = T4.ClientQuotationProductId AND T1.[ServiceFeeTriggerTimeId] = T4.[ServiceFeeTriggerTimeId]
			WHERE T3.QuotationNumber = @QuotationNumber
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
			WHERE T3.QuotationNumber = @QuotationNumber
			AND T1.[Status] = 1
			
			DECLARE @ProductCode VARCHAR(50)
			DECLARE @ProductType TINYINT
			DECLARE @SoldPriceWithTax NUMERIC(15,4)
			DECLARE @FaceValueWithTax INT
			DECLARE @ValidityFrom DATETIME
			DECLARE @ValidityEnd DATETIME
			DECLARE @OrderLineTrustAccountId INT
			DECLARE @OrderLineId INT
			DECLARE @soldId INT
			
			DECLARE product_cursor CURSOR FOR
			SELECT * FROM #ProductTemp
			
			OPEN product_cursor
			FETCH NEXT FROM product_cursor INTO @ProductCode, @soldId
			
			WHILE @@FETCH_STATUS = 0
			BEGIN
				IF @soldId IS NULL
				BEGIN
					FETCH NEXT FROM product_cursor INTO @ProductCode, @soldId
					CONTINUE;--Ã»ÓÐ±ä¼ÛµÄÎÞÐè´¦Àí
				END

				SELECT TOP 1 @ProductType = P.ProductType, @SoldPriceWithTax = CQPSP.SoldPriceWithTax, @FaceValueWithTax = PPV.FaceValueWithTax, @ValidityFrom = CQPSP.ValidityFrom, @ValidityEnd = CQPSP.ValidityEnd
				FROM ClientQuotationProductSoldPrice CQPSP
				INNER JOIN ClientQuotationProduct CQP ON CQPSP.ClientQuotationProductId = CQP.Id
				INNER JOIN ClientQuotation CQ ON CQP.ClientQuotationId = CQ.Id
				INNER JOIN ProductVersion PV ON CQP.ProductVersionId = PV.Id
				INNER JOIN Product P ON PV.ProductId = P.Id
				LEFT OUTER JOIN ProductPricingValueBased PPV ON PV.ProductPricingValueBasedId = PPV.Id
				WHERE CQ.QuotationNumber = @QuotationNumber AND P.ProductCode = @ProductCode
				ORDER BY CQPSP.Id DESC
				
				DECLARE trust_cursor CURSOR FOR
				SELECT MAX(OLTA.Id) Id, OLTA.OrderLineId
				FROM ClientQuotation CQ
				INNER JOIN ClientQuotationProduct CQP ON CQ.Id = CQP.ClientQuotationId
				INNER JOIN ProductVersion PV ON CQP.ProductVersionId = PV.Id
				INNER JOIN Product P ON PV.ProductId = P.Id
				INNER JOIN OrderLine OL ON CQP.Id = OL.ClientQuotationProductId
				INNER JOIN OrderLineTrustAccount OLTA ON OL.Id = OLTA.OrderLineId
				WHERE CQ.QuotationNumber = @QuotationNumber AND P.ProductCode = @ProductCode
				AND OLTA.TrustAccountOption = 0 -- Default
				GROUP BY OLTA.OrderLineId
				
				OPEN trust_cursor
				FETCH NEXT FROM trust_cursor INTO @OrderLineTrustAccountId, @OrderLineId
				
				WHILE @@FETCH_STATUS = 0
				BEGIN
					INSERT INTO OrderLineTrustAccount (OrderLineId, TrustAccountId, TrustAccountOption, TrustAccountBatchNo, Amount, ExpiryPolicyId, ExpiryDate, ValidFrom, ValidTo)
					SELECT OrderLineId, TrustAccountId, TrustAccountOption, TrustAccountBatchNo, 
					CASE @ProductType 
						WHEN 1 THEN @SoldPriceWithTax 
						WHEN 2 THEN @FaceValueWithTax
						ELSE 1
					END,
					ExpiryPolicyId, ExpiryDate, @ValidityFrom, ValidTo
					FROM OrderLineTrustAccount
					WHERE Id = @OrderLineTrustAccountId
					
					UPDATE OrderLineTrustAccount SET ValidTo = DATEADD(SS, -1, @ValidityFrom) WHERE Id = @OrderLineTrustAccountId

					FETCH NEXT FROM trust_cursor INTO @OrderLineTrustAccountId, @OrderLineId
				END
				
				CLOSE trust_cursor
				DEALLOCATE trust_cursor
				
				FETCH NEXT FROM product_cursor INTO @ProductCode, @soldId
			END
			
			CLOSE product_cursor
			DEALLOCATE product_cursor
			
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
			ROLLBACK TRANSACTION;
	END CATCH

END

