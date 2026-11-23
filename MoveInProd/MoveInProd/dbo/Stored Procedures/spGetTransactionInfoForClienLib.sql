-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spGetTransactionInfoForClienLib
	-- Add the parameters for the stored procedure here
	@VoucherNumber varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [TranRealDateTime]
		,[TranAmount]
		,[BalanceAvailable]
		,ISNULL(T2.[Name],'') AS ShopName
		,ISNULL([Rsv1],'') AS Rsv1
	FROM [dbo].[Transaction] AS T1
	LEFT JOIN [dbo].[Shop] AS T2 ON T1.ShopId = T2.Id
	WHERE [AccountNumber] = @VoucherNumber

END
