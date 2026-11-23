CREATE PROCEDURE [dbo].[spReverseActivatePreIssuedAccounts_ae120720]
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
	,@FilterByStatus 		BIT
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
	 AND Status = IIF(@FilterByStatus = 0, Status, 2)

	 if @@ROWCOUNT <> 0
	 begin
		declare @ProgramCode varchar(20)
			select @ProgramCode = [IdentityCode] FROM [dbo].[Program] where [Id] = @ProgramId

			Insert into [dbo].[AccountToGenReverseActivatePreIssuedTran](AccountNumber,ProgramCode,CreatedOn,Amount)
			Values(IIF(@UseThirdPartyAccountNumber = 1, @ThirdPartyAccountNumber, @AccountNumber), @ProgramCode,@LastTranOn,@Balance)

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
