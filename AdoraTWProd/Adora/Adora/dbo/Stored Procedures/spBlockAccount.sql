-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/05/08
-- Description:	Block account.
-- =============================================
CREATE PROCEDURE spBlockAccount
	@AccountNumber			varchar(50)
	,@ProgramId				int
	,@AccountCheckSum		varchar(50)
	,@IsHistory				bit
	,@IsSuccess				bit			output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if @IsHistory > 0
	begin
		UPDATE [dbo].[AccountHistory]
		   SET [Checksum] = @AccountCheckSum
			  ,[Status] = 16
			  ,[BlockedOn] = GETUTCDATE()
			  ,[ModifyVersion] = [ModifyVersion] + 1
		 WHERE [AccountNumber] = @AccountNumber and [ProgramId] = @ProgramId
	end
	else
	begin
		UPDATE [dbo].[Account]
		   SET [Checksum] = @AccountCheckSum
			  ,[Status] = 16
			  ,[BlockedOn] = GETUTCDATE()
			  ,[ModifyVersion] = [ModifyVersion] + 1
		 WHERE [AccountNumber] = @AccountNumber and [ProgramId] = @ProgramId
	end

	if @@ROWCOUNT <> 0
	 begin
		set @IsSuccess = 1
	end
	else
	begin
		set @IsSuccess = 0
	end
END
