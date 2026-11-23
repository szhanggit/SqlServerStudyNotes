
CREATE PROCEDURE [dbo].[spGetQuotationApprovalInfo_TW] 
	-- Add the parameters for the stored procedure here
	@QuotationNumber varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/* ==ProductType== 
	 *
	 * ProductBased = 1
     * ValueBased = 2
	 *
	 */     
    -- Insert statements for procedure here
	BEGIN TRY 
		CREATE TABLE #NewSoldPriceTable
		(
			[Id] INT
			,[NewValidityFrom] DATETIME
			,[ProductNewSoldPrice] NUMERIC(15,4)
		)
		CREATE TABLE #ApprovedSoldPriceTable
		(
			[Id] INT
			,[ProductApprovedSoldPrice] NUMERIC(15,4)
		)
		CREATE TABLE #NewFeeSoldPriceTable
		(
			[Id] INT
			,[NewValidityFrom] DATETIME
			,[ProductNewFeeSoldPrice] NUMERIC(15,4)
			,[ServiceFee] NVARCHAR(50)	
			,ServiceFeeId INT
			,[TranType] SMALLINT
		)
		CREATE TABLE #ApprovedFeeSoldPriceTable
		(
			[Id] INT
			,[ProductApprovedFeeSoldPrice] NUMERIC(15,4)
			,ServiceFeeId INT
			,[TranType] SMALLINT
		)
		/* Get last sold price.	*/

		INSERT INTO #NewSoldPriceTable
		SELECT  
			[Id]
			,[ValidityFrom]
			,[ProductSoldPrice]
		FROM (
			SELECT
				T1.Id
				,T5.ValidityFrom
				,CASE
					WHEN T4.ProductType = 1 THEN T5.[SoldPriceWithTax]
					WHEN T4.ProductType = 2 THEN
						CASE
							WHEN T4.ProductSubType = 4 THEN T5.SoldPricePercentage
							ELSE T5.[ValueBasedSoldPriceWithTax]
						END
					ELSE 0
				 END AS ProductSoldPrice
				,ROW_NUMBER() OVER (PARTITION BY T5.ClientQuotationProductId ORDER BY T5.[ValidityFrom] DESC) NewIndex
				--,COUNT(1) OVER (PARTITION BY T5.ClientQuotationProductId) rowLength
			FROM [dbo].[ClientQuotationProduct] AS T1 WITH (NOLOCK)
				INNER JOIN [dbo].[ClientQuotation] AS T2 WITH (NOLOCK) ON T1.ClientQuotationId = T2.Id		
				INNER JOIN [dbo].[ProductVersion] AS T3 WITH (NOLOCK) ON T1.ProductVersionId = T3.Id
				INNER JOIN [dbo].[Product] AS T4 WITH (NOLOCK) ON T3.ProductId = T4.Id
				INNER JOIN [dbo].[ClientQuotationProductSoldPrice] AS T5 ON T1.Id = T5.ClientQuotationProductId
			WHERE T2.QuotationNumber = @QuotationNumber
				--AND (T1.[Status] < 32 OR (T1.[Status] = 32 AND T5.[Status] = 1)) --32:Approval
			) AS Temp
		WHERE Temp.NewIndex = 1

		/* Get last approved sold price.*/
		INSERT INTO #ApprovedSoldPriceTable
		SELECT  
			[Id]
			,[ProductSoldPrice]
		FROM (
			SELECT
				T1.Id
				,CASE
					WHEN T4.ProductType = 1 THEN T6.[SoldPriceWithTax]
					WHEN T4.ProductType = 2 THEN
						CASE
							WHEN T4.ProductSubType = 4 THEN T6.SoldPricePercentage
							ELSE T6.[ValueBasedSoldPriceWithTax]
						END
					ELSE 0
				 END AS ProductSoldPrice
				,ROW_NUMBER() OVER (PARTITION BY T6.ClientQuotationProductId ORDER BY T6.[ValidityFrom] DESC) NewIndex
			FROM [dbo].[ClientQuotationProduct] AS T1 WITH (NOLOCK)
				INNER JOIN [dbo].[ClientQuotation] AS T2 WITH (NOLOCK) ON T1.ClientQuotationId = T2.Id		
				INNER JOIN [dbo].[ProductVersion] AS T3 WITH (NOLOCK) ON T1.ProductVersionId = T3.Id
				INNER JOIN [dbo].[Product] AS T4 WITH (NOLOCK) ON T3.ProductId = T4.Id
				--INNER JOIN [dbo].[ClientQuotationProductSoldPrice] AS T5 ON T1.Id = T5.ClientQuotationProductId
				INNER JOIN [dbo].[ClientQuotationProductSoldPrice] AS T6 ON T1.Id = T6.ClientQuotationProductId
			WHERE T2.QuotationNumber = @QuotationNumber
				--AND (T1.[Status] < 32 OR (T1.[Status] = 32 AND T5.[Status] = 1)) --32:Approval
				AND T6.[Status] = 2
			) AS Temp
		WHERE Temp.NewIndex = 1

		/* Get last fee sold price.*/
		INSERT INTO #NewFeeSoldPriceTable
		SELECT 
			[Id]
			,[ValidityFrom]
			,[SoldPriceWithTax]
			,[ServiceFee]
			,ServiceFeeId
			,[TranType]
		FROM (
			SELECT T2.[Id]
				,T3.[SoldPriceWithTax]
				,T3.[ValidityFrom]
				,T6.[Name] AS [ServiceFee]
				,T4.ServiceFeeId
				,T4.[TranType]
				,ROW_NUMBER() OVER (PARTITION BY T3.ClientQuotationProductId,T3.ServiceFeeTriggerTimeId ORDER BY T3.[ValidityFrom] DESC) NewIndex
			FROM ClientQuotation AS T1
			INNER JOIN ClientQuotationProduct AS T2 ON T1.Id = T2.ClientQuotationId
			INNER JOIN ClientQuotationProductServiceFeeTriggerTime AS T3 ON T2.Id = T3.ClientQuotationProductId
			LEFT JOIN [dbo].[ServiceFeeTriggerTime] AS T4 WITH (NOLOCK) ON T3.ServiceFeeTriggerTimeId = T4.Id
			LEFT JOIN [dbo].[ServiceFee] AS T5 WITH (NOLOCK) ON T4.ServiceFeeId = T5.Id
			LEFT JOIN [dbo].[Dictionary] AS T6 WITH (NOLOCK) ON T5.ServiceFeeNameId = T6.Id
			WHERE T1.QuotationNumber = @QuotationNumber
				--AND (T2.[Status] < 32 OR (T2.[Status] = 32 AND T3.[Status] = 1)) --32:Approval
			) AS Temp
		WHERE Temp.NewIndex = 1

		/* Get lastest approved fee sold price.*/
		INSERT INTO #ApprovedFeeSoldPriceTable
		SELECT 
			[Id]
			,[SoldPriceWithTax]
			,[ServiceFeeId]
			,[TranType]
		FROM (
			SELECT T2.[Id]
				,T4.[SoldPriceWithTax]
				,T5.ServiceFeeId
				,T5.TranType
				,ROW_NUMBER() OVER (PARTITION BY T4.ClientQuotationProductId,T4.ServiceFeeTriggerTimeId ORDER BY T3.[ValidityFrom] DESC) NewIndex
			FROM ClientQuotation AS T1
			INNER JOIN ClientQuotationProduct AS T2 ON T1.Id = T2.ClientQuotationId
			INNER JOIN ClientQuotationProductServiceFeeTriggerTime AS T3 ON T2.Id = T3.ClientQuotationProductId
			INNER JOIN ClientQuotationProductServiceFeeTriggerTime AS T4 ON T2.Id = T4.ClientQuotationProductId
			LEFT JOIN [dbo].[ServiceFeeTriggerTime] AS T5 WITH (NOLOCK) ON T4.ServiceFeeTriggerTimeId = T5.Id
			WHERE T1.QuotationNumber = @QuotationNumber
				AND (T2.[Status] < 32 OR (T2.[Status] = 32 AND T3.[Status] = 1)) --32:Approval
				AND T4.[Status] = 2
			) AS Temp
		WHERE Temp.NewIndex = 1

		SELECT BusinessModel
			,BusinessModelId
			,IsPrepaid  
			,ProductCode
			,ProductName
			,TEMP.ProductType
			,ProjectName
			,MultipleSelectionType
			,QuotationNumber
			,QuotationId
			,ValidFrom
			,ValidTo
			,Sales
			,ClientName
			,ProductCodePrefix
			,[ExpiryScheme]
			,[MarketPrice]
			,[DefaultSellingPrice]
			,[Cost]
			,MaxIssueVoucherNumber
			,T16.[ProductNewSoldPrice] AS [ProductSoldPrice]
			,T16.[NewValidityFrom] AS [SoldPriceValidityFrom]
			,T17.[ProductApprovedSoldPrice] AS [ProductApprovedSoldPrice]
			,T14.[ServiceFee]
			,T14.[TranType]   
			,T14.NewValidityFrom AS [FeeValidityFrom]
			,T14.[ProductNewFeeSoldPrice] AS FeeSoldPrice
			,T15.[ProductApprovedFeeSoldPrice] AS ApprovedFeeSoldPrice 
		FROM 
		(
			SELECT DISTINCT CQP.Id 
				,BMD.Name AS BusinessModel
				,BM.Id AS BusinessModelId
				,BM.IsPrepaid  
				,P.ProductCode
				,P.ProductSubType AS ProductType
				,PV.ProductName
				,CQ.ProjectName
				,CASE WHEN P.IsMasterProduct = 1 THEN 'Master'
					WHEN P.IsMasterProduct = 2 THEN 'Child'
					ELSE 'General' END AS [MultipleSelectionType]
				,CQ.QuotationNumber
				,CQ.Id AS QuotationId
				,CQ.ValidFrom
				,CQ.ValidTo
				,CQ.Sales
				,C.Name AS ClientName
				,SUBSTRING(P.ProductCode,1,3) AS ProductCodePrefix
				,EPD.Name AS [ExpiryScheme]
				,CASE
					WHEN P.ProductType = 1 THEN CAST(ISNULL(PPPB.FaceValueWithTax, 0) / 100.00 AS NUMERIC(15, 2))
					WHEN P.ProductType = 2 THEN
						CASE
							WHEN P.ProductSubType = 4 THEN 0
							ELSE CAST(ISNULL(PPVB.FaceValueWithTax, 0) / 100.00 AS NUMERIC(15, 2))
						END
					ELSE 0
				 END AS [MarketPrice]
				,CASE
					WHEN P.ProductType = 1 THEN CASE BM.IsPrepaid WHEN 1 THEN ISNULL(PPPB.SellingPricePrepaidWithTax,0) ELSE ISNULL(PPPB.SellingPricePostpaidWithTax,0) END
					WHEN P.ProductType = 2 THEN
						CASE
							WHEN P.ProductSubType = 4 THEN CONVERT(DECIMAL(10,6), ISNULL(ppdfv.DefaultSellingPrice,0)) / 100
							ELSE ISNULL(PPVB.SellingPricePrepaidWithTax,0)
						END
					ELSE 0
				 END AS [DefaultSellingPrice]
				,CASE
					WHEN P.ProductType = 1 THEN ISNULL(PPPB.CostWithTax,0)
					WHEN P.ProductType = 2 THEN
						CASE
							WHEN P.ProductSubType = 4 THEN CONVERT(DECIMAL(10,6), ISNULL(ppdfv.DefaultProductCost,0)) / 100
							ELSE CAST((ISNULL(PPVB.FaceValueWithTax,0) * ISNULL(PPVB.MerchantFeeWithTax,0))/10000.0000 AS NUMERIC(15,4))
						END
					ELSE 0
				 END AS [Cost]
				,ISNULL(CQP.MaxIssueVoucherNumber,1) AS MaxIssueVoucherNumber
				,T14.ServiceFeeId
				,T14.TranType
			FROM [dbo].[ClientQuotationProduct] AS CQP WITH (NOLOCK)
				INNER JOIN [dbo].[ClientQuotation] AS CQ WITH (NOLOCK) ON CQP.ClientQuotationId = CQ.Id
				INNER JOIN [dbo].[ProductVersion] AS PV WITH (NOLOCK) ON CQP.ProductVersionId = PV.Id
				INNER JOIN [dbo].[Product] AS P WITH (NOLOCK) ON PV.ProductId = P.Id
				INNER JOIN [dbo].[Client] AS C WITH (NOLOCK) ON  CQ.ClientId = C.Id
				INNER JOIN [dbo].[BusinessModel] AS BM WITH (NOLOCK) ON CQ.BusinessModelId = BM.Id
				INNER JOIN [dbo].[Dictionary] AS BMD WITH (NOLOCK) ON BM.DisplayNameId = BMD.Id
				LEFT JOIN [dbo].[ProductPricingProductBased] AS PPPB WITH (NOLOCK) ON PV.ProductPricingProductBasedId = PPPB.Id
				LEFT JOIN [dbo].[ProductPricingValueBased] AS PPVB WITH (NOLOCK) ON PV.ProductPricingValueBasedId = PPVB.Id
				LEFT JOIN [dbo].ProductPricingDynamicFaceValue AS ppdfv WITH (NOLOCK) ON ppdfv.ProductVersionId = PV.Id
				INNER JOIN [dbo].[ExpirationPolicy] AS EP WITH (NOLOCK) ON CQP.ExpirySchemeId = EP.Id
				INNER JOIN [dbo].[Dictionary] AS EPD WITH (NOLOCK) ON EP.DisplayNameId = EPD.Id
				INNER JOIN [dbo].[ClientQuotationProductSoldPrice] AS T13 ON T13.ClientQuotationProductId = CQP.Id
				LEFT JOIN  [dbo].[ClientQuotationProductServiceFeeTriggerTime] AS CQPSFT WITH (NOLOCK) ON CQPSFT.ClientQuotationProductId = CQP.Id
				LEFT JOIN [dbo].[ServiceFeeTriggerTime] AS T14 WITH (NOLOCK) ON CQPSFT.ServiceFeeTriggerTimeId = T14.Id
			WHERE CQ.QuotationNumber = @QuotationNumber
		) AS TEMP
		LEFT JOIN #NewFeeSoldPriceTable AS T14 ON TEMP.Id = T14.Id AND T14.TranType = TEMP.TranType AND T14.ServiceFeeId = TEMP.[ServiceFeeId]
		LEFT JOIN #ApprovedFeeSoldPriceTable AS T15 ON TEMP.Id = T15.Id AND T15.TranType = TEMP.TranType AND T15.ServiceFeeId = TEMP.[ServiceFeeId]
		LEFT JOIN #NewSoldPriceTable AS T16 ON TEMP.Id = T16.Id
		LEFT JOIN #ApprovedSoldPriceTable AS T17 ON TEMP.Id = T17.Id

		IF EXISTS(SELECT 1 FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#NewSoldPriceTable'))
			DROP TABLE #NewSoldPriceTable
		IF EXISTS(SELECT 1 FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#ApprovedSoldPriceTable'))
			DROP TABLE #ApprovedSoldPriceTable
		IF EXISTS(SELECT 1 FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#NewFeeSoldPriceTable'))
			DROP TABLE #NewFeeSoldPriceTable
		IF EXISTS(SELECT 1 FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#ApprovedFeeSoldPriceTable'))
			DROP TABLE #ApprovedFeeSoldPriceTable

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			IF EXISTS(SELECT 1 FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#NewSoldPriceTable'))
				DROP TABLE #NewSoldPriceTable
			IF EXISTS(SELECT 1 FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#ApprovedSoldPriceTable'))
				DROP TABLE #ApprovedSoldPriceTable
			IF EXISTS(SELECT 1 FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#NewFeeSoldPriceTable'))
				DROP TABLE #NewFeeSoldPriceTable
			IF EXISTS(SELECT 1 FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#ApprovedFeeSoldPriceTable'))
				DROP TABLE #ApprovedFeeSoldPriceTableROLLBACK 
		END
	END CATCH
END
