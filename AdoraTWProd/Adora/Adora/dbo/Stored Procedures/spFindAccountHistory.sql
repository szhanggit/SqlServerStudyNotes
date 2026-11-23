-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/12/05
-- Description:	Find Account History
-- =============================================
CREATE PROCEDURE spFindAccountHistory
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
	FROM [dbo].[AccountHistory]
	WHERE [AccountNumber] = @AcountNumber AND [ProgramId] = @ProgramId
END
