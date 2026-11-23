
CREATE PROCEDURE [dbo].[spUpdateBulkDividedTasksMessageEntity]
@UpdatedTable BulkDividedTasksMessageEntityType READONLY,
@IsSuccess bit output
AS
BEGIN
    SET NOCOUNT ON;

	BEGIN TRY
	BEGIN TRAN
		DECLARE @UpdatedCount int;
		DECLARE @InitCount int;
		
		SET @InitCount = (SELECT count(1) FROM (select distinct BulkDividedTasksId,MessageId from @UpdatedTable) t );

		UPDATE bdtm SET bdtm.MessageSPId = UT.SPId, bdtm.MessageStatus = UT.SPStatus, bdtm.SentOnUTC = GetUTCDate()  from BulkDividedTasksMessages bdtm with(NOLOCK) INNER JOIN @UpdatedTable UT ON bdtm.BulkDividedTasksId = UT.BulkDividedTasksId AND bdtm.MessageId = UT.MessageId;
		
		set @UpdatedCount = @@ROWCOUNT;
		
		IF (@InitCount = @UpdatedCount)
		BEGIN
			set @IsSuccess = 1;
			COMMIT TRANSACTION;
		END
		ELSE
		BEGIN
			set @IsSuccess = 0;
			ROLLBACK TRANSACTION;
		END
	END TRY
	BEGIN CATCH
		select ERROR_MESSAGE() as Message;
		set @IsSuccess = 0
		ROLLBACK TRANSACTION;
	END CATCH;
END;
