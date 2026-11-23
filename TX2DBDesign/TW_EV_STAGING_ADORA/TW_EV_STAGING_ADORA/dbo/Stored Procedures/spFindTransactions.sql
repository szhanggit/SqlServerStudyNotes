-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/5/28
-- Description:	Find Transactions
-- =============================================
CREATE PROCEDURE spFindTransactions
	-- Add the parameters for the stored procedure here
	@AcountNumber		varchar(50)
	,@ProgramCode		varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [TranUtcDateTime] AS [Date]
			,[TranCode]
			,[TranType] AS [Type]
			,ISNULL(M.Name, T.MerchantCode) AS Merchant
			,[TranAmount] AS Amount
			,[IsCleared] AS Cleared
			,CAST(0 AS BIT) AS IsHistory
	FROM [dbo].[Transaction] T
	LEFT JOIN [dbo].[Merchant] M on T.MerchantCode = M.IdentityCode
	WHERE T.AccountNumber = @AcountNumber AND T.ProgramCode = @ProgramCode
	UNION
	SELECT [TranUtcDateTime] AS [Date]
			,[TranCode]
			,[TranType] AS [Type]
			,ISNULL(M.Name, TH.MerchantCode) AS Merchant
			,[TranAmount] AS Amount
			,[IsCleared] AS Cleared
			,CAST(1 AS BIT) AS IsHistory
	FROM [dbo].[TransactionHistory] TH
	LEFT JOIN [dbo].[Merchant] M on TH.MerchantCode = M.IdentityCode
	WHERE TH.AccountNumber = @AcountNumber AND TH.ProgramCode = @ProgramCode
END
