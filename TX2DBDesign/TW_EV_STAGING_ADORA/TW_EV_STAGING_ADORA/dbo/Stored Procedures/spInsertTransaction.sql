
-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/04/23
-- Description:	Insert transaction.
-- =============================================
CREATE PROCEDURE spInsertTransaction @AccountNumber VARCHAR(50)
	,@ProgramCode VARCHAR(50)
	,@MerchantCode VARCHAR(50)
	,@TerminalSSN VARCHAR(50)
	,@TranUtcDateTime DATETIME
	,@TranUtcDateTimeL BIGINT
	,@TranTerminalDateTime DATETIME
	,@TranRealDateTime DATETIME = NULL
	,@ShopCode VARCHAR(50) = NULL
	,@TerminalCode VARCHAR(50) = NULL
	,@TranType SMALLINT
	,@TranAmount INT
	,@NodeNum INT
	,@CallerIP VARCHAR(50) = NULL
	,@Channel VARCHAR(20)
	,@Parameters NVARCHAR(4000)
	,@TranCodeRef VARCHAR(50) = NULL
	,@SettleDate INT = NULL
	,@BusinessDay INT = NULL
	,@TranLocalDateTime DATETIME = NULL
	,@TranLocalDate INT = NULL
	,@Rsv1 NVARCHAR(255) = NULL
	,@Rsv2 NVARCHAR(255) = NULL
	,@Rsv3 NVARCHAR(255) = NULL
	,@TranCode VARCHAR(50) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @HostSsn VARCHAR(12)
	DECLARE @TranUtcDate VARCHAR(8)

	SET @HostSsn = NEXT value
	FOR HostSsn_Sequence
	SET @HostSsn = right(replicate('0', 9) + @HostSsn, 9)
	SET @TranUtcDate = substring(cast(@TranUtcDateTimeL AS VARCHAR(14)), 1, 8)
	SET @TranCode = @ProgramCode + @MerchantCode + @TranUtcDate + @HostSsn

	INSERT INTO [dbo].[Transaction] (
		[AccountNumber]
		,[ProgramCode]
		,[MerchantCode]
		,[HostSSN]
		,[TerminalSSN]
		,[TranUtcDateTime]
		,[TranUtcDateTimeL]
		,[TranTerminalDateTime]
		,[ShopCode]
		,[TerminalCode]
		,[TranType]
		,[TranAmount]
		,[NodeNum]
		,[CallerIP]
		,[Channel]
		,[Parameters]
		,[TranCode]
		,[TranCodeRef]
		,[TranGUID]
		,[TranRealDateTime]
		,[SettleDate]
		,[TranUtcDate]
		,[TranLocalDate]
		,[TranLocalDateTime]
		,[Rsv1]
		,[Rsv2]
		,[Rsv3]
		,[BusinessDay]
		)
	VALUES (
		@AccountNumber
		,@ProgramCode
		,@MerchantCode
		,@HostSsn
		,@TerminalSSN
		,@TranUtcDateTime
		,@TranUtcDateTimeL
		,@TranTerminalDateTime
		,@ShopCode
		,@TerminalCode
		,@TranType
		,@TranAmount
		,@NodeNum
		,@CallerIP
		,@Channel
		,@Parameters
		,@TranCode
		,@TranCodeRef
		,NEWID()
		,ISNULL(@TranRealDateTime, @TranUtcDateTime)
		,@SettleDate
		,cast(@TranUtcDate AS INT)
		,@TranLocalDate
		,@TranLocalDateTime
		,@Rsv1
		,@Rsv2
		,@Rsv3
		,@BusinessDay
		)
END
