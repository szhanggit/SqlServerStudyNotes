
CREATE PROCEDURE spActivateAccounts
	@ExternalOrderId			varchar(50),
	@IsSuccess					bit				output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY
		DECLARE @CurrentDateTime DATETIME
		SET @CurrentDateTime = GETUTCDATE()

		UPDATE [dbo].[Account]
		SET [ActiveFrom] = @CurrentDateTime
		WHERE [ExternalOrderId] = @ExternalOrderId AND (ActiveFrom < '1900-1-1 00:00:01' OR ActiveFrom > '3900-1-1 00:00:01')

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
