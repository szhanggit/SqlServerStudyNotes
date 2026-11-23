-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/05/08
-- Description:	Block account.
-- =============================================
CREATE PROCEDURE spBlockSingleAccount
	@AccountNumber			varchar(50)
	,@ProgramId				int
    ,@Status				int
	,@LastTranOn			datetime
	,@BlockedOn			    datetime
	,@ModifyVersion			int
	,@LastTranDate			int
	,@LastTranTime			bigint
	,@Checksum			    varchar(50)
	,@ResponseCode			varchar(5)	output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [dbo].[Account]
	   SET [Status] = @Status
	      ,[Checksum] = @Checksum	 
		  ,BlockedOn = @BlockedOn
		  ,LastTranOn = @LastTranOn
		  ,LastTranDate =@LastTranDate
		  ,LastTranTime = @LastTranTime
		  ,[ModifyVersion] = [ModifyVersion] + 1		
	 WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId

	IF(@@ROWCOUNT > 0)
		SET @ResponseCode = '0000'
	ELSE
		SET @ResponseCode = '0018'	
			
END
