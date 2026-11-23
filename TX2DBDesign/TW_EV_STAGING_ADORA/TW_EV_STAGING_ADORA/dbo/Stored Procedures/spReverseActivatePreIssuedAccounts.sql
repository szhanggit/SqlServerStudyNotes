CREATE PROCEDURE spReverseActivatePreIssuedAccounts
	@AccountNumber			varchar(50)
	,@ProgramId				int
	,@AccountCheckSum		varchar(50)
	,@ModifyVersion			int
	,@Status				int
	,@LastTranOn			datetime
	,@ActiveFrom			datetime
	,@ActiveTo				datetime
	,@ActivatedOn			datetime
	,@Balance               int
	,@IsNotifyClient        bit
	,@ClientNotificationProviderCode  varchar(50)
	,@ExpirationPolicyId    int
	,@ExternalOrderId       varchar(50)
	,@ThirdPartyAccountNumber			varchar(50) = NULL
	,@UseThirdPartyAccountNumber BIT
    ,@IsSuccess				bit			output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY

    UPDATE [dbo].[Account]
	   SET [Checksum] = @AccountCheckSum
		  ,[TranCount] = [TranCount] + 2
		  ,[ModifyVersion] = [ModifyVersion] + 1
		  ,[Status] = @Status
		  ,[LastTranOn] = @LastTranOn
		  ,[ActiveFrom] = '39990101'
		  ,[ActiveTo] = '39990101'
		  ,[ActivatedOn] = NULL
		  ,[IsNotifyClient] = 0
		  ,[ClientNotificationProviderCode] = NULL
		  ,[ExternalOrderId] = NULL
		  ,[AccountNumber] = @AccountNumber
		  ,[MasterAccountNumber] = NULL
		  ,[MasterProgramIdentityCode] = NULL
		  ,MasterRedemptionTranCode = NULL
		  ,MasterRedemptionTranAmount = NULL
	 WHERE [AccountNumber] = IIF(@UseThirdPartyAccountNumber = 1, @ThirdPartyAccountNumber, @AccountNumber) and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId
	 AND Status = 2

	 if @@ROWCOUNT <> 0
	 begin
		declare @ProgramCode varchar(20)
		select @ProgramCode = [IdentityCode] FROM [dbo].[Program] where [Id] = @ProgramId

		--1. if 401 402 in buffer table, delete
		--2. if 401 402 in tran table, set code 9999
		--3. if 401 402 had sync, do 501 502 , 不用 因为一定没同步
		IF @Status = 256
		BEGIN
			DECLARE @accountNum VARCHAR(50) = IIF(@UseThirdPartyAccountNumber = 1, @ThirdPartyAccountNumber, @AccountNumber);
		
			DELETE dbo.AccountToGenTranV2 WHERE AccountNumber = @accountNum AND ProgramCode = @ProgramCode AND TranType = 401;
			IF @@ROWCOUNT = 0
			BEGIN
				UPDATE dbo.[Transaction] SET ResponseCode = '9999' WHERE AccountNumber = @accountNum AND ProgramCode = @ProgramCode AND TranType = 401;
			END

			DELETE dbo.AccountToGenTranV2 WHERE AccountNumber = @accountNum AND ProgramCode = @ProgramCode AND TranType = 402;
			IF @@ROWCOUNT = 0
			BEGIN
				UPDATE dbo.[Transaction] SET ResponseCode = '9999' WHERE AccountNumber = @accountNum AND ProgramCode = @ProgramCode AND TranType = 402;
			END
		END

		IF @Status = 16 --Reupload Or Reissue
		BEGIN
			Insert into [dbo].[AccountToGenReverseActivatePreIssuedTran](AccountNumber,ProgramCode,CreatedOn,Amount)
			Values(IIF(@UseThirdPartyAccountNumber = 1, @ThirdPartyAccountNumber, @AccountNumber), @ProgramCode,@LastTranOn,@Balance)
		END

		set @IsSuccess = 1
	end
	else
	begin
		set @IsSuccess = 0
	end

	END TRY
	BEGIN CATCH
		set @IsSuccess = 0
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
			RETURN;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END