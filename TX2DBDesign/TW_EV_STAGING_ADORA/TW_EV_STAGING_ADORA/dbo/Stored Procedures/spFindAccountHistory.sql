CREATE PROCEDURE spFindAccountHistory
	-- Add the parameters for the stored procedure here
	@AcountNumber		varchar(50)
	,@ProgramId			int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		AccountNumber,
		ProgramId,
		ProductId,
		ExternalOrderId,
		AccountNumberHashed,
		BalanceAvailable,
		BalanceFrozen,
		ValueType,
		TopupMode,
		Status,
		Checksum,
		TranCount,
		TranAmountAccumulated,
		AcceptanceLoopId,
		RestrictionId,
		ExpirationPolicyId,
		Password,
		ActiveFrom,
		ActiveTo,
		CreatedOn,
		LastTranOn,
		LastTranDate,
		LastTranTime,
		BlockedOn,
		ActivatedOn,
		ExpiredOn,
		ModifyVersion,
		AccountNumberLength,
		AccountGUID,
		IsNotifyClient,
		ClientNotificationProviderCode,
		ConsumeTime,
		ConsumeMerchantCode,
		ConsumeShopCode,
		ConsumeTerminalSSN,
		BalanceInitialized,
		PinCode,
		MasterAccountNumber,
		MasterRedemptionTranCode,
		MasterProgramIdentityCode,
		SequenceNumber,
		MasterRedemptionTranAmount
	FROM [dbo].[AccountHistory]
	WHERE [AccountNumber] = @AcountNumber AND [ProgramId] = @ProgramId
END
