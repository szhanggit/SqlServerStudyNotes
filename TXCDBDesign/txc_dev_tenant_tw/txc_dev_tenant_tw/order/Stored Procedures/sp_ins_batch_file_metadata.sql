CREATE PROCEDURE [order].[sp_ins_batch_file_metadata]
(
    -- Add the parameters for the stored procedure here
	@RemoteLoc nvarchar(250),
	@Size bigint,
	@SaveDate datetime,
	@FileName nvarchar(250),
	@Status int,
	@IsSuccess bit output
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
	SET XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;
        
		INSERT INTO [order].tb_bf_batch_file
		(
			remote_location,
			size,
			saved_date,
			[file_name],
			[status],
			optimistic_lock
		)
		VALUES
		(
			@RemoteLoc,
			@Size,
			@SaveDate,
			@FileName,
			@Status,
			null
		)
		
		IF @@ROWCOUNT = 0
			BEGIN
				SET @IsSuccess = 0;
				ROLLBACK TRANSACTION;
			END
        ELSE
			BEGIN
				SET @IsSuccess = 1;
				COMMIT TRANSACTION;
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