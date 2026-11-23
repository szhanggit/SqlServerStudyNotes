
CREATE PROCEDURE [dbo].[spUpdateEmailOrSMSMessagesByBulkDividedTasksMessages]
@BulkDividedTasksId bigint,
@IsSuccess bit output
AS
BEGIN
    SET NOCOUNT ON;

	BEGIN TRY
	BEGIN TRAN
		DECLARE @MessageType int;
		SET @IsSuccess = 0;

		SET @MessageType = (SELECT distinct bdtm.MessageType FROM BulkDividedTasksMessages bdtm with(NOLOCK) WHERE bdtm.BulkDividedTasksId = @BulkDividedTasksId);

		IF(@MessageType = 2)
		BEGIN
			UPDATE s SET s.MessageSPId = bdtm.MessageSPId, s.MessageStatus= bdtm.MessageStatus, s.SentOn = bdtm.SentOnUTC from dbo.SLMSMessage s with(NOLOCK) INNER JOIN dbo.BulkDividedTasksMessages bdtm with(NOLOCK) ON s.Id = bdtm.MessageId WHERE bdtm.BulkDividedTasksId = @BulkDividedTasksId;
		END
		
		IF(@@ROWCOUNT > 0)
		BEGIN
			set @IsSuccess = 1;
			COMMIT TRANSACTION;
		END
	END TRY
	BEGIN CATCH
		select ERROR_MESSAGE() as Message;
		set @IsSuccess = 0
		ROLLBACK TRANSACTION;
	END CATCH;
END;
