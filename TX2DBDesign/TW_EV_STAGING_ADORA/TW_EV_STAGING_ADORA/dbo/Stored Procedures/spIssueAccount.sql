-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/07/16
-- Description:	Issue account.
-- =============================================
CREATE PROCEDURE spIssueAccount
	@AccountNumber			varchar(50)
	,@ProgramId				int
	,@ProductId				int
	,@ExternalOrderId		varchar(50)	=	null
	,@AccountNumberHashed	varchar(50)
	,@BalanceAvailable		int
	,@BalanceFrozen			int
	,@ValueType				int
	,@TopupMode				int
	,@AcceptanceLoopId		int
	,@RestrictionId			int
	,@ExpirationPolicyId	int	=	NULL
	,@AccountCheckSum		varchar(50)
	,@Status				int
	,@LastTranOn			datetime
	,@ActiveFrom			datetime
	,@ActiveTo				datetime
	,@CreatedOn				datetime
	,@AccountNumberLength	tinyint
	,@MerchantCode			varchar(50)
	,@TerminalSSN			varchar(50)
	,@TranType				smallint
	,@TranAmount			int
	,@SecurityKeyId			int
	,@Checksum				varchar(50)
	,@TranLocalDateTime		datetime
	,@TranLocalDate			int
	,@TranUtcDateTime		datetime
	,@TranUtcDateTimeL		bigint
	,@AccountGuid			uniqueidentifier
	,@IsSuccess				bit			output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY
	INSERT INTO [dbo].[Account]
           ([AccountNumber],[ProgramId],[ProductId],[ExternalOrderId],[AccountNumberHashed],[BalanceAvailable],[BalanceFrozen],[ValueType],[TopupMode],[Status],[Checksum],[TranCount]
		   ,[TranAmountAccumulated],[AcceptanceLoopId],[RestrictionId],[ExpirationPolicyId],[ActiveFrom],[ActiveTo],[CreatedOn],[LastTranOn],[ModifyVersion],[AccountNumberLength],[AccountGUID])
     VALUES(
			@AccountNumber,@ProgramId,@ProductId,@ExternalOrderId,@AccountNumberHashed,@BalanceAvailable,@BalanceFrozen,@ValueType,@TopupMode,@Status,@AccountCheckSum,0,0,@AcceptanceLoopId,@RestrictionId
			,@ExpirationPolicyId,@ActiveFrom,@ActiveTo,@CreatedOn,@CreatedOn,0,@AccountNumberLength,@AccountGuid
			)

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
	select @ProgramCode = [IdentityCode] FROM [dbo].[Program] where [Id] = @ProgramId
	set @TranUtcDate = substring(cast(@TranUtcDateTimeL as varchar(14)), 1, 8)

	INSERT INTO [dbo].[Transaction]
			([AccountNumber],[ProgramCode],[MerchantCode],[HostSSN],[TerminalSSN],[TranUtcDateTime],[TranType],[TranAmount],[TranCode],[TranGUID],[ModifyVersion],[BalanceAvailable]
			,[SecurityKeyId],[Checksum],[TranLocalDateTime],[TranLocalDate],[ResponseCode],[TranRealDateTime],[TranUtcDate],[TranUtcDateTimeL])
		VALUES
			(@AccountNumber,@ProgramCode,@MerchantCode,@HostSsn,@TerminalSSN,@LastTranOn,@TranType,@TranAmount,@ProgramCode + @MerchantCode + @TranUtcDate + @HostSsn,NEWID(),0,@TranAmount,@SecurityKeyId
			,@Checksum,@TranLocalDateTime,@TranLocalDate,'0000',@LastTranOn,cast(@TranUtcDate as int),@TranUtcDateTimeL)
	END TRY
	BEGIN CATCH
		set @IsSuccess = 0
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END
