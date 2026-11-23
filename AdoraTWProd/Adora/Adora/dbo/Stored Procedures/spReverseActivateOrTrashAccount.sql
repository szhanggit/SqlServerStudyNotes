
CREATE PROCEDURE dbo.spReverseActivateOrTrashAccount
	@AccountNumber			varchar(50)
	,@ProgramId				int
	,@AccountCheckSum		varchar(50)
	,@ModifyVersion			int
	,@Status				int
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
	,@CallerIp				varchar(50)	= null
	,@IsSuccess				bit			output
	,@TranCode				varchar(50) output
	,@ActiveFrom			datetime = null
AS
BEGIN
    SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY

    UPDATE [dbo].[Account]
	 SET [Checksum] = @AccountCheckSum
		  ,[TranCount] = [TranCount] + 1
		  ,[ModifyVersion] = [ModifyVersion] + 1
		  ,[Status] = @Status
		  ,[LastTranOn] = @LastTranOn
		  ,[ActiveFrom] = @ActiveFrom
	 WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId

	 if @@ROWCOUNT <> 0
	 begin
		declare @HostSsn varchar(12), @ProgramCode varchar(50)
		declare @TranUtcDate varchar(8)
		set @HostSsn = next value for HostSsn_Sequence
		set @HostSsn = right(replicate('0',9)+@HostSsn,9)
		select @ProgramCode = [IdentityCode] FROM [dbo].[Program] where [Id] = @ProgramId
		set @TranUtcDate = substring(cast(@TranUtcDateTimeL as varchar(14)), 1, 8)
		DECLARE @OutputTbl TABLE (TranCode varchar(50));

		INSERT INTO [dbo].[Transaction]
				([AccountNumber],[ProgramCode],[MerchantCode],[HostSSN],[TerminalSSN],[TranUtcDateTime],[TranUtcDateTimeL],[TranType],[TranAmount],[TranCode],[TranGUID],[ModifyVersion],[BalanceAvailable]
				,[SecurityKeyId],[Checksum],[TranLocalDateTime],[TranLocalDate],[ResponseCode],[TranRealDateTime],[TranUtcDate],[CallerIP])
				OUTPUT INSERTED.[TranCode] INTO @OutputTbl(TranCode)
			VALUES
				(@AccountNumber,@ProgramCode,@MerchantCode,@HostSsn,@TerminalSSN,@LastTranOn,@TranUtcDateTimeL,@TranType,@TranAmount,@ProgramCode + @MerchantCode + @TranUtcDate + @HostSsn,NEWID()
				,@ModifyVersion + 1,@TranAmount,@SecurityKeyId,@Checksum,@TranLocalDateTime,@TranLocalDate,'0000',@LastTranOn,cast(@TranUtcDate as int),@CallerIp)
		set @IsSuccess = 1;
		select @TranCode = TranCode from @OutputTbl;
	end
	else
	begin
		set @IsSuccess = 0;
	end
	
	
	END TRY
	BEGIN CATCH
		set @IsSuccess = 0
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END;

