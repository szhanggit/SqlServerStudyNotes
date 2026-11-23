
CREATE PROCEDURE dbo.spActivateAccount
	@AccountNumber			varchar(50)
	,@ProgramId				int
	,@AccountCheckSum		varchar(50)
	,@ModifyVersion			int
	,@Status				int
	,@LastTranOn			datetime
	,@ActiveFrom			datetime
	,@ActiveTo				datetime
	,@ActivatedOn			datetime
	,@MerchantCode			varchar(50)
	,@TerminalSSN			varchar(50)
	,@TranUtcDateTimeL		bigint
	,@TranType				smallint
	,@TranAmount			int
	,@SecurityKeyId			int
	,@Checksum				varchar(50)
	,@TranLocalDateTime		datetime
	,@TranLocalDate			int
	,@IsSuccess				bit			output
	,@TranCode				varchar(50) output
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
		  ,[ActiveTo] = @ActiveTo
		  ,[ActivatedOn] = @ActivatedOn
	 WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId

	 DECLARE @ResponseCode	VARCHAR(4)

	 if @@ROWCOUNT <> 0
	 begin
		set @IsSuccess = 1
		set @ResponseCode = '0000'
	end
	else
	begin
		set @IsSuccess = 0
		set @ResponseCode = '0018'
	end

	declare @HostSsn varchar(12), @ProgramCode varchar(50)
	declare @TranUtcDate varchar(8)
	set @HostSsn =next value for HostSsn_Sequence
	set @HostSsn = right(replicate('0',9)+@HostSsn,9)
	select @ProgramCode = [IdentityCode] FROM [dbo].[Program] where [Id] = @ProgramId
	set @TranUtcDate = substring(cast(@TranUtcDateTimeL as varchar(14)), 1, 8)
	DECLARE @OutputTbl TABLE (TranCode varchar(50));

	INSERT INTO [dbo].[Transaction]
			([AccountNumber],[ProgramCode],[MerchantCode],[TranUtcDateTimeL],[HostSSN],[TerminalSSN],[TranUtcDateTime],[TranType],[TranAmount],[TranCode],[TranGUID],[ModifyVersion],[BalanceAvailable]
			,[SecurityKeyId],[Checksum],[TranLocalDate],[TranLocalDateTime],[ResponseCode],[TranRealDateTime],[TranUtcDate])
			OUTPUT INSERTED.[TranCode] INTO @OutputTbl(TranCode)
		VALUES
			(@AccountNumber,@ProgramCode,@MerchantCode,@TranUtcDateTimeL,@HostSsn,@TerminalSSN,@LastTranOn,@TranType,@TranAmount,@ProgramCode + @MerchantCode + @TranUtcDate + @HostSsn,NEWID()
			,@ModifyVersion + 1,@TranAmount,@SecurityKeyId,@Checksum,@TranLocalDate,@TranLocalDateTime,@ResponseCode,@LastTranOn,cast(@TranUtcDate as int));
	select @TranCode = TranCode from @OutputTbl;		
	END TRY
	BEGIN CATCH
		set @IsSuccess = 0
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END


