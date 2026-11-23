-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/7/17
-- Description: Generate dashboard report
-- =============================================
CREATE PROCEDURE spGenerateDashboardReport
	-- Add the parameters for the stored procedure here
	@ReportInterval		tinyint
	,@StartDate			datetime
	,@EndDate			datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @ReportInterval > 0
	BEGIN
		SELECT   TranLocalDate
				,[ProgramCode]
				,P.DisplayName ProductName
				,M.Name MerchantName
				,[TranType]
				,TranCount
				,TranAmount
		FROM(
			SELECT   TranLocalDate
					,[ProgramCode]
					,[ProductId]
					,[MerchantId]
					,[TranType]
					,SUM([TranCount]) TranCount
					,SUM([TranAmount]) TranAmount
			FROM (
				SELECT   SUBSTRING([TranLocalDate],1,6) AS TranLocalDate
						,[ProgramCode]
						,[ProductId]
						,[MerchantId]
						,[TranType]
						,[TranCount]
						,[TranAmount]
				FROM [dbo].[BatchClearStatistics]
				WHERE CAST(TranLocalDate AS DATE)<=CONVERT(DATE, @EndDate,120) AND CAST(TranLocalDate AS DATE)>=CONVERT(DATE, @StartDate,120)) AS S
			GROUP BY TranLocalDate,[ProgramCode],[ProductId],[MerchantId],[TranType]) AS G
		INNER JOIN [dbo].Product P ON G.ProductId = P.Id
		INNER JOIN [dbo].Merchant M ON G.MerchantId = M.Id
	END
	ELSE
	BEGIN
		SELECT   TranLocalDate
				,[ProgramCode]
				,P.DisplayName ProductName
				,M.Name MerchantName
				,[TranType]
				,TranCount
				,TranAmount
		FROM(
			SELECT   TranLocalDate
					,[ProgramCode]
					,[ProductId]
					,[MerchantId]
					,[TranType]
					,SUM([TranCount]) TranCount
					,SUM([TranAmount]) TranAmount
			FROM (
				SELECT   TranLocalDate
						,[ProgramCode]
						,[ProductId]
						,[MerchantId]
						,[TranType]
						,[TranCount]
						,[TranAmount]
				FROM [dbo].[BatchClearStatistics]
				WHERE CAST(TranLocalDate AS DATE)<=CONVERT(DATE, @EndDate,120) AND CAST(TranLocalDate AS DATE)>=CONVERT(DATE, @StartDate,120)) AS S
			GROUP BY TranLocalDate,[ProgramCode],[ProductId],[MerchantId],[TranType]) AS G
		INNER JOIN [dbo].Product P ON G.ProductId = P.Id
		INNER JOIN [dbo].Merchant M ON G.MerchantId = M.Id
	END
END
