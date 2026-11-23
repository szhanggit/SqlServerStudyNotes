
CREATE PROCEDURE [dbo].[spUpdateAccountStatus]
	@AccountNumber			varchar(50)
	,@ProgramId				int
	,@AccountCheckSum		varchar(50)
	,@ModifyVersion			int
	,@Status				int
	,@LastTranOn			datetime
	,@ThirdPartyAccountNumber			varchar(50) = NULL
	,@UseThirdPartyAccountNumber BIT
	,@TranAmount			int
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
		  ,[BalanceAvailable] = [BalanceAvailable] + @TranAmount
		  ,[Status] = @Status
		  ,[LastTranOn] = @LastTranOn
	 WHERE [AccountNumber] = IIF(@UseThirdPartyAccountNumber = 1, @ThirdPartyAccountNumber, @AccountNumber)
	 and [ModifyVersion] = @ModifyVersion
	 and [ProgramId] = @ProgramId	 

	set @IsSuccess = 1
	
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
