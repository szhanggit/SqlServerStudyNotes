-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/12/05
-- Description:	Update Transaction
-- =============================================
CREATE PROCEDURE spUpdateTransactionForError
	-- Add the parameters for the stored procedure here
	@AcountNumber			varchar(50)
	,@TranCode				varchar(50)
	,@ResponseCode			varchar(5)
	,@BalanceAvailable		int
	,@BalanceFrozen			int
	,@ModifyVersion			int
	,@TranLocalDateTime		datetime		=	NULL
	,@TranLocalDate			int				=	NULL
	,@ErrorMessage			nvarchar(4000)				OUTPUT
	,@ErrorLine				int							OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
		UPDATE [dbo].[Transaction]
		SET ResponseCode=@ResponseCode
			,BalanceAvailable=@BalanceAvailable
			,BalanceFrozen=@BalanceFrozen
			,ModifyVersion=@ModifyVersion
			,TranLocalDateTime=ISNULL(@TranLocalDateTime, TranLocalDateTime)
			,TranLocalDate=ISNULL(@TranLocalDate, TranLocalDate)
		WHERE AccountNumber=@AcountNumber AND TranCode=@TranCode
	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE()
		SELECT @ErrorLine = ERROR_LINE()
	END CATCH
END
