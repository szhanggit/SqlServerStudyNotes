
-- Stored Procedure

-- =============================================
-- Author:		Zhu Jianhua
-- Create date: 2017-12-01
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[spGetMerchantContractForDownload]
	@MerchantId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;
	DECLARE @CurrentDate DATETIME	
	SET @CurrentDate = GETDATE()

	/*
	 *Get Transaction Type Info.
	 */
	SELECT Id
		,DisplayName 
	FROM [dbo].[Dictionary]
	WHERE [Category] = 'TransactionType'
	ORDER BY Id
	/*
	 * GET Merchant Contract Info.
	 */
	SELECT  
		Temp.Id
		,Temp.ProductCode
		,REPLACE(CONVERT(varchar(100),Temp.ValidFrom, 23),'-','/') AS ValidFrom
		,REPLACE(CONVERT(varchar(100),Temp.ValidTo, 23),'-','/') AS ValidTo
	FROM (
		SELECT
			T1.Id
			,T3.ProductCode
			,T1.ValidFrom
			,T1.ValidTo
			,ROW_NUMBER() OVER (PARTITION BY T2.ProductId ORDER BY T1.[ValidTo] DESC) NewIndex
		FROM [MerchantContract] AS T1
			INNER JOIN [dbo].[ProductVersion] AS T2 ON T1.ProductVersionId= T2.Id
			INNER JOIN [dbo].[Product] AS T3 ON T2.ProductId = T3.Id
		WHERE T1.MerchantId = @MerchantId
			AND T3.[Status] =1
		) AS Temp
	WHERE Temp.NewIndex = 1	


	/*
	 * GET Reimbursement Scheme Info.
	 */
	SELECT MerchantContractId
		,TransactionTypeId
		,Value
	FROM ReimbursementScheme AS T1
	INNER JOIN (
		SELECT  
				Temp.Id
		FROM (
			SELECT
				T1.Id
				,ROW_NUMBER() OVER (PARTITION BY T1.ProductVersionId ORDER BY T1.[ValidTo] DESC) NewIndex
			FROM [dbo].[MerchantContract] AS T1
			INNER JOIN [dbo].[ProductVersion] AS T2 ON T1.ProductVersionId= T2.Id
			INNER JOIN [dbo].[Product] AS T3 ON T2.ProductId = T3.Id
			WHERE T1.MerchantId = @MerchantId
				AND T3.[Status] =1
			) AS Temp
		WHERE Temp.NewIndex = 1
	) AS T2
	ON T1.MerchantContractId = T2.Id
	ORDER BY MerchantContractId,TransactionTypeId,Value

END

