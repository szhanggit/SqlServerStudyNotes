
-- =============================================
-- Author:		Knight YAO
-- Create date: 2014/05/08
-- Description:	Insert Sogo Transaction.
-- =============================================
CREATE PROCEDURE [dbo].[spInsertSGTransaction] @MemberId INT
	,@MerchantCode VARCHAR(50)
	,@ShopCode VARCHAR(50) = NULL
	,@TerminalCode VARCHAR(50) = NULL
	,@TerminalSSN VARCHAR(50)
	,@TerminalTranDateTime DATETIME
	,@ServerTranDateTime DATETIME = NULL
	,@TranType SMALLINT
	,@Status TINYINT
	,@GAmount INT
	,@PAmount INT
	,@NodeNum INT = NULL
	,@CallerIP VARCHAR(50) = NULL
	,@TranCode VARCHAR(50)
	,@TranCodeRef VARCHAR(50) = NULL
	,@ModifyVersion INT
	,@GiveToMemberId INT = NULL
	,@TerminalTranId varchar(50) = null
	,@InvoiceDetail varchar(150) = null
	,@TerminalTranDate int = null
	,@TerminalTranTime int = null
AS
BEGIN
	SET NOCOUNT ON;
  if (@TerminalTranId is null)
    set @TerminalTranId=newid()
    
	INSERT INTO [dbo].[SGTransaction] (
		[MemberId]
		,[MerchantCode]
		,[ShopCode]
		,[TerminalCode]
		,[TerminalSSN]
		,[TerminalTranDateTime]
		,[ServerTranDateTime]
		,[TranType]
		,[Status]
		,[GAmount]
		,[PAmount]
		,[NodeNum]
		,[CallerIP]
		,[TranCode]
		,[TranCodeRef]
		,[ModifyVersion]
		,[GiveToMemberId]
		,[TerminalTranId]
		,[InvoiceDetail]
		,[TerminalTranDate]
		,[TerminalTranTime]
		)
	VALUES (
		 @MemberId
		,@MerchantCode
		,@ShopCode
		,@TerminalCode
		,@TerminalSSN
		,@TerminalTranDateTime
		,@ServerTranDateTime
		,@TranType
		,@Status
		,@GAmount
		,@PAmount
		,@NodeNum
		,@CallerIP
		,@TranCode
		,@TranCodeRef
		,@ModifyVersion
		,@GiveToMemberId
		,@TerminalTranId
		,@InvoiceDetail
		,@TerminalTranDate
		,@TerminalTranTime
		)
END
