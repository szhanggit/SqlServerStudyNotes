-- =============================================
-- Author:		Zhu Jianhua
-- Create date: 2016-10-19
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetTransactionByAccountNumber] 
	-- Add the parameters for the stored procedure here
	@AccountNumber VARCHAR(50),
	@ProgramCode VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TOP 1
		T.MerchantCode
		,M.Name AS MerchantName
		,T.[ShopCode]
		,S.Name AS ShopName
		,T.TranLocalDateTime
	FROM [Transaction] AS T
		LEFT JOIN Merchant AS M ON T.MerchantId = M.Id
		LEFT JOIN Shop AS S ON T.ShopId = S.Id
	WHERE AccountNumber = @AccountNumber
		AND [ProgramCode] = @ProgramCode
		AND TranType = 101
		AND ResponseCode = '0000'
	ORDER BY TranRealDateTime DESC
END

