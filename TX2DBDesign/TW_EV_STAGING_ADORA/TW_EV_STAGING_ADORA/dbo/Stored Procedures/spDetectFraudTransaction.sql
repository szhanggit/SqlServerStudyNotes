-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/5/23
-- Description:	This is used to detect fraud transaction
-- =============================================
CREATE PROCEDURE spDetectFraudTransaction
	@BatchId				bigint
	,@ProgramCode			varchar(20)
	,@ErrorMessage			nvarchar(4000)	OUTPUT
	,@ErrorLine				int				OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @CurrentDateTime DATETIME
	SET @CurrentDateTime = GETUTCDATE()

    INSERT INTO [dbo].[BatchFraudTransaction]
           ([BatchId]
           ,[ProgramCode]
           ,[IdentityCode]
           ,[IdentityType]
           ,[AccountNumber]
           ,[TranCode]
           ,[TranType]
           ,[ResponseCode])
     SELECT 
           @BatchId
           ,@ProgramCode
           ,[IdentityCode]
           ,[IdentityType]
           ,[AccountNumber]
           ,[TranCode]
           ,[TranType]
           ,[ResponseCode]
	FROM (
	SELECT ISNULL(ISNULL([TerminalCode], [ShopCode]), [MerchantCode]) AS IdentityCode
			,CASE	WHEN [TerminalCode] IS NOT NULL THEN 1
					WHEN [ShopCode] IS NOT NULL THEN 2
					WHEN [MerchantCode] IS NOT NULL THEN 3
			END AS IdentityType
			,[AccountNumber]
			,[TranCode]
			,[TranType]
			,[ResponseCode]
	FROM [dbo].[Transaction] T
	INNER JOIN (		  
			SELECT IdentityCode, Id, [dbo].[fnCalcLocalDate](DATEADD(dd, -1, @CurrentDateTime), [TimeOffset]) AS LocalDate FROM [dbo].[Program]
			WHERE NOT EXISTS 
			(SELECT NULL FROM [dbo].[Batch] 
			WHERE [dbo].[fnCalcLocalDate]([StartTime], [TimeOffset]) = [dbo].[fnCalcLocalDate](@CurrentDateTime, [TimeOffset])
			AND [Status] > 3 AND [BatchType] = 32)) AS P on P.IdentityCode = @ProgramCode AND T.TranLocalDate = P.LocalDate
	WHERE ResponseCode IN ('0001', '0036', '0011', '0021')) AS Source
END
