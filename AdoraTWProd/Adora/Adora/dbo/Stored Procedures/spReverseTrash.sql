

CREATE PROCEDURE [dbo].[spReverseTrash] @AccountNumber VARCHAR(50)
	,@ProgramId INT
	,@MachineKey VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN 

	UPDATE [dbo].[Account]
	SET [Status] = 2
		,[Checksum] = SUBSTRING(sys.fn_varbintohexstr(HASHBYTES('MD5', CONVERT(VARCHAR(500), CONVERT(VARCHAR, ProgramId) 
				+ '=' + AccountNumber 
				+ '=' + CONVERT(VARCHAR(10), ValueType) 
				+ '=' + CONVERT(VARCHAR(20), BalanceAvailable) 
				+ '=' + CONVERT(VARCHAR(20), BalanceFrozen) 
				+ '=2' +
				+ '=' + @MachineKey))), 3, 32)
		,[LastTranOn] = GETUTCDATE()
	WHERE [Status] = 8
		AND [ActivatedOn] IS NOT NULL
		AND [AccountNumber] = @AccountNumber
		AND [ProgramId] = @ProgramId

	IF @@ROWCOUNT > 0
	BEGIN
		COMMIT TRAN 

		RETURN 1
	END
	ELSE
	BEGIN
		UPDATE [dbo].[AccountHistory]
		SET [Status] = 2
			,[Checksum] = SUBSTRING(sys.fn_varbintohexstr(HASHBYTES('MD5', CONVERT(VARCHAR(500), CONVERT(VARCHAR, ProgramId) 
					+ '=' + AccountNumber 
					+ '=' + CONVERT(VARCHAR(10), ValueType) 
					+ '=' + CONVERT(VARCHAR(20), BalanceAvailable) 
					+ '=' + CONVERT(VARCHAR(20), BalanceFrozen) 
					+ '=2' +
					+ '=' + @MachineKey))), 3, 32)
			,[LastTranOn] = GETUTCDATE()
		WHERE [Status] = 8
			AND [ActivatedOn] IS NOT NULL
			AND [AccountNumber] = @AccountNumber
			AND [ProgramId] = @ProgramId

		IF @@ROWCOUNT > 0
		BEGIN
			INSERT INTO [dbo].[Account] (
				[AccountNumber]
				,[ProgramId]
				,[ProductId]
				,[ExternalOrderId]
				,[AccountNumberHashed]
				,[BalanceAvailable]
				,[BalanceFrozen]
				,[ValueType]
				,[TopupMode]
				,[Status]
				,[Checksum]
				,[TranCount]
				,[TranAmountAccumulated]
				,[AcceptanceLoopId]
				,[RestrictionId]
				,[ExpirationPolicyId]
				,[Password]
				,[ActiveFrom]
				,[ActiveTo]
				,[CreatedOn]
				,[LastTranOn]
				,[BlockedOn]
				,[ActivatedOn]
				,[ExpiredOn]
				,[ModifyVersion]
				,[AccountNumberLength]
				,[AccountGUID]
				)
			SELECT [AccountNumber]
				,[ProgramId]
				,[ProductId]
				,[ExternalOrderId]
				,[AccountNumberHashed]
				,[BalanceAvailable]
				,[BalanceFrozen]
				,[ValueType]
				,[TopupMode]
				,[Status]
				,[Checksum]
				,[TranCount]
				,[TranAmountAccumulated]
				,[AcceptanceLoopId]
				,[RestrictionId]
				,[ExpirationPolicyId]
				,[Password]
				,[ActiveFrom]
				,[ActiveTo]
				,[CreatedOn]
				,[LastTranOn]
				,[BlockedOn]
				,[ActivatedOn]
				,[ExpiredOn]
				,[ModifyVersion]
				,[AccountNumberLength]
				,[AccountGUID]
			FROM [dbo].[AccountHistory]
			WHERE [AccountNumber] = @AccountNumber
				AND [ProgramId] = @ProgramId

			DELETE
			FROM [dbo].[AccountHistory]
			WHERE [AccountNumber] = @AccountNumber
				AND [ProgramId] = @ProgramId

			COMMIT TRAN 

			RETURN 1
		END
		ELSE
		BEGIN
			ROLLBACK TRAN

			RETURN 0
		END
	END

END

