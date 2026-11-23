CREATE PROCEDURE [order].[sp_any_file_name]
(
	@FileName nvarchar(250),
	@IsExists bit output
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
	SET XACT_ABORT ON;

    BEGIN TRY

	SET @IsExists = 1;

	IF EXISTS (SELECT * FROM [order].[tb_bf_batch_file] WHERE [file_name] = @FileName)
		BEGIN
			SET @IsExists = 1;
		END
	ELSE
		BEGIN
			SET @IsExists = 0;
		END

    END TRY
    BEGIN CATCH 

       IF @@TRANCOUNT > 0
       BEGIN
          ROLLBACK TRANSACTION
       END;

	   THROW;
    END CATCH;

    SET NOCOUNT, XACT_ABORT OFF;
END