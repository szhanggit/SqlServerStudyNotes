
-- =============================================
-- Author:		Knight YAO
-- Create date: 2014/05/08
-- Description:	Activate account.
-- =============================================
CREATE PROCEDURE [dbo].[spActivatePreIssuedAccountForThirdParty]
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
	,@ThirdPartyAccountNumber			varchar(50)
	,@MasterAccountNumber   varchar(50) = NULL
	,@MasterProgramIdentityCode   varchar(20) = NULL
	,@IsSuccess				bit			output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	set @IsSuccess=0

	BEGIN TRAN

	BEGIN TRY
	  if(@ClientNotificationProviderCode='')
	     set @ClientNotificationProviderCode =null
	     
		UPDATE [dbo].[Account]
		   SET [Checksum] = @AccountCheckSum
			  ,[ModifyVersion] = [ModifyVersion] + 1
			  ,[Status] = @Status
			  ,[LastTranOn] = @LastTranOn
			  ,[CreatedOn] = @LastTranOn
			  ,[ActiveFrom] = @ActiveFrom
			  ,[ActiveTo] = @ActiveTo
			  ,[ActivatedOn] = @ActivatedOn
			  ,[IsNotifyClient] = @IsNotifyClient
			  ,[ClientNotificationProviderCode] = @ClientNotificationProviderCode
			  ,[ExpirationPolicyId] = @ExpirationPolicyId
			  ,[ExternalOrderId] = @ExternalOrderId
			  ,AccountNumber = @ThirdPartyAccountNumber
			  ,[MasterAccountNumber] = @MasterAccountNumber
			  ,[MasterProgramIdentityCode] = @MasterProgramIdentityCode
		 WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId

		 DECLARE @ResponseCode	VARCHAR(4)

		 if @@ROWCOUNT <> 0
		 begin
			declare @ProgramCode varchar(20)
			select @ProgramCode = [IdentityCode] FROM [dbo].[Program] where [Id] = @ProgramId

			Insert into [dbo].[AccountToGenTran](AccountNumber,ProgramCode,CreatedOn,Amount)
			Values(@ThirdPartyAccountNumber,@ProgramCode,@LastTranOn,@Balance)

			set @IsSuccess = 1
		end
		else
		begin
			set @IsSuccess = 0
		end

	END TRY
	BEGIN CATCH
		set @IsSuccess = 0
	    ROLLBACK TRANSACTION
		return
	END CATCH

	COMMIT TRANSACTION;
END

