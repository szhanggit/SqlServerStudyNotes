-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/5/28
-- Description:	Find Accounts
-- =============================================
CREATE PROCEDURE spFindAccount
	-- Add the parameters for the stored procedure here
	@AcountNumber		varchar(50)
	,@ProgramId			int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [ProductId],[BalanceAvailable],[BalanceFrozen],[ValueType],[TopupMode],[Status],[Checksum],[TranCount],[TranAmountAccumulated],[AcceptanceLoopId],[RestrictionId]
		,[ExpirationPolicyId],[ActiveFrom],[ActiveTo],[ModifyVersion],[IsNotifyClient],[ClientNotificationProviderCode],AccountGUID,PinCode,BalanceInitialized,MasterAccountNumber,MasterProgramIdentityCode
	FROM [dbo].[Account]
	WHERE [AccountNumber] = @AcountNumber AND [ProgramId] = @ProgramId
END
