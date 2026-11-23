-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/07/22
-- Description:	Reverse expire account.
-- =============================================
CREATE PROCEDURE spReverseExpireAccount
	@AccountNumber			varchar(50)
	,@ProgramId				int
	,@AccountCheckSum		varchar(50)
	,@ModifyVersion			int
	,@Status				int
	,@ActiveTo				datetime
	,@LastTranOn			datetime
	,@MerchantCode			varchar(50)
	,@TerminalSSN			varchar(50)
	,@TranUtcDateTimeL		bigint
	,@TranType				smallint
	,@TranAmount			int
	,@SecurityKeyId			int
	,@Checksum				varchar(50)
	,@TranLocalDateTime		datetime
	,@TranLocalDate			int
	,@IsHistory				bit
	,@IsSuccess				bit			output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY
	IF(@IsHistory=0)
	BEGIN
	    UPDATE [dbo].[Account]
		   SET [Checksum] = @AccountCheckSum
			  ,[TranCount] = [TranCount] + 1
			  ,[ModifyVersion] = [ModifyVersion] + 1
			  ,[Status] = @Status
			  ,[LastTranOn] = @LastTranOn
			  ,[ActiveTo] = @ActiveTo
			  --,[ActivatedOn] = @LastTranOn
		WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId
	END
	ELSE
	BEGIN
		UPDATE [dbo].[AccountHistory]
		   SET [Checksum] = @AccountCheckSum
			  ,[TranCount] = [TranCount] + 1
			  ,[ModifyVersion] = [ModifyVersion] + 1
			  ,[Status] = @Status
			  ,[ActiveTo] = @ActiveTo
			  ,[LastTranOn] = @LastTranOn
			  --,[ActivatedOn] = @LastTranOn
		WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId

		INSERT INTO [dbo].[Account]
			   ([AccountNumber],[ProgramId],[ProductId],[ExternalOrderId],[AccountNumberHashed],[BalanceAvailable],[BalanceFrozen],[ValueType],[TopupMode],[Status],[Checksum],[TranCount]
			   ,[TranAmountAccumulated],[AcceptanceLoopId],[RestrictionId],[ExpirationPolicyId],[Password],[ActiveFrom],[ActiveTo],[CreatedOn],[LastTranOn],[BlockedOn],[ActivatedOn],[ExpiredOn]
			   ,[ModifyVersion],[AccountNumberLength],[AccountGUID],[IsNotifyClient],[ClientNotificationProviderCode],[ConsumeTime],[ConsumeMerchantCode],[ConsumeShopCode],[ConsumeTerminalSSN],[BalanceInitialized]
			   ,[PinCode])
		 SELECT [AccountNumber],[ProgramId],[ProductId],[ExternalOrderId],[AccountNumberHashed],[BalanceAvailable],[BalanceFrozen],[ValueType],[TopupMode],[Status],[Checksum],[TranCount]
				,[TranAmountAccumulated],[AcceptanceLoopId],[RestrictionId],[ExpirationPolicyId],[Password],[ActiveFrom],[ActiveTo],[CreatedOn],[LastTranOn],[BlockedOn],[ActivatedOn],[ExpiredOn]
				,[ModifyVersion],[AccountNumberLength],[AccountGUID],[IsNotifyClient],[ClientNotificationProviderCode],[ConsumeTime],[ConsumeMerchantCode],[ConsumeShopCode],[ConsumeTerminalSSN],[BalanceInitialized]
				,[PinCode]
		FROM [dbo].[AccountHistory]
		WHERE [AccountNumber] = @AccountNumber and [ProgramId] = @ProgramId

		DELETE FROM [dbo].[AccountHistory]
		WHERE [AccountNumber] = @AccountNumber and [ProgramId] = @ProgramId
	END

	 if @@ROWCOUNT <> 0
	 begin
		set @IsSuccess = 1
	end
	else
	begin
		set @IsSuccess = 0
	end

	IF @IsSuccess = 1
	begin
	declare @HostSsn varchar(12), @ProgramCode varchar(50)
	declare @TranUtcDate varchar(8)
	set @HostSsn = next value for HostSsn_Sequence
	set @HostSsn = right(replicate('0',9)+@HostSsn,9)
	select @ProgramCode = [IdentityCode] FROM [dbo].[Program] where [Id] = @ProgramId
	set @TranUtcDate = substring(cast(@TranUtcDateTimeL as varchar(14)), 1, 8)

	INSERT INTO [dbo].[Transaction]
			([AccountNumber],[ProgramCode],[MerchantCode],[HostSSN],[TerminalSSN],[TranUtcDateTime],[TranUtcDateTimeL],[TranType],[TranAmount],[TranCode],[TranGUID],[ModifyVersion],[BalanceAvailable]
			,[SecurityKeyId],[Checksum],[TranLocalDateTime],[TranLocalDate],[ResponseCode],[TranRealDateTime],[TranUtcDate])
		VALUES
			(@AccountNumber,@ProgramCode,@MerchantCode,@HostSsn,@TerminalSSN,@LastTranOn,@TranUtcDateTimeL,@TranType,@TranAmount,@ProgramCode + @MerchantCode + @TranUtcDate + @HostSsn,NEWID()
			,@ModifyVersion + 1,@TranAmount,@SecurityKeyId,@Checksum,@TranLocalDateTime,@TranLocalDate,'0000',@LastTranOn,cast(@TranUtcDate as int))
	end
	END TRY
	BEGIN CATCH
		set @IsSuccess = 0
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END
