-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/07/22
-- Description:	Extend account.
-- =============================================
CREATE PROCEDURE spExtendAccount
	@AccountNumber			varchar(50)
	,@ProgramId				int
	,@ModifyVersion			int
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
	,@IsSuccess				bit			output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY
    UPDATE [dbo].[Account]
	   SET [TranCount] = [TranCount] + 1
		  ,[ModifyVersion] = [ModifyVersion] + 1
		  ,[ActiveTo] = @ActiveTo
		  ,[LastTranOn] = @LastTranOn
	 WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId

	 if @@ROWCOUNT <> 0
	 begin
		set @IsSuccess = 1
	end
	else
	begin
		set @IsSuccess = 0
	end

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
	END TRY
	BEGIN CATCH
		set @IsSuccess = 0
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END
