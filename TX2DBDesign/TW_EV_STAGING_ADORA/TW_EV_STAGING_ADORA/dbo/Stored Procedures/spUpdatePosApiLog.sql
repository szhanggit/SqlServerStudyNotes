
CREATE PROCEDURE [dbo].[spUpdatePosApiLog]
    @LogId INT,
	@TranCode VARCHAR(50),
	@ResponseCode VARCHAR(50) ,
	@ResponsedOn DATETIME ,
	@ResponseMessage nvarchar(max),
	@Comment nvarchar(max) = NULL,
    @IsSuccess BIT OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRAN

        BEGIN TRY

			UPDATE [dbo].[APILog_POS]
			   SET 
				  [TranCode] = @TranCode
				  ,[ResponseCode] = @ResponseCode
				  ,[ResponsedOn] = GETDATE()
				  ,[ResponseMessage] = @ResponseMessage
				  ,[Comment] = @Comment
			 WHERE Id = @LogId

            SET @IsSuccess = 1
		 
        END TRY
        BEGIN CATCH
            SET @IsSuccess = 0
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
    END

