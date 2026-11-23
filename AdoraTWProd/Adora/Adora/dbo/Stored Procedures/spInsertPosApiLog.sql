
CREATE PROCEDURE [dbo].[spInsertPosApiLog]
    @MerchantCode varchar(50) ,
	@ShopCode varchar(50) ,
	@TerminalSSN varchar(50) ,
	@TranType varchar(50) ,
	@RequestMessage nvarchar(max),
	@RequestId varchar(50) = NULL ,
	@LogId INT OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRAN

        BEGIN TRY

            INSERT INTO [dbo].[APILog_POS]
				   ([MerchantCode]
				   ,[ShopCode]
				   ,[TerminalSSN]
				   ,[TranType]
				   ,[CreatedOn]
				   ,[RequestMessage]
				   ,[RequestId])
			 VALUES
				   (@MerchantCode
				   ,@ShopCode
				   ,@TerminalSSN
				   ,@TranType
				   ,GETDATE()
				   ,@RequestMessage
				   ,@RequestId)

			SET @LogId = SCOPE_IDENTITY()
		 
        END TRY
        BEGIN CATCH
            SET @LogId = 0
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
    END

