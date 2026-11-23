
CREATE PROCEDURE [dbo].[pi_ArchiveSLMSMessage]
	@Days INT,
	@ErrorMessage NVARCHAR(4000) OUTPUT,
	@ErrorLine INT OUTPUT
AS
BEGIN

BEGIN TRAN

BEGIN TRY
	DECLARE @ArchiveDateTime DATETIME = GETUTCDATE()
	DECLARE @CutOffDateTime DATETIME = DATEADD(DAY, -1 * @Days, @ArchiveDateTime)
	DECLARE @SessionId VARCHAR(50) = NEWID()
	
	-- 'Insert ArchiveLog'
	INSERT INTO ArchiveLog (MessageType, ArchiveDateTime, CutOffDateTime, SessionId)
	VALUES (2, @ArchiveDateTime, @CutOffDateTime, @SessionId)
	
	-- 'Insert SLMSMesageArchiveTemp'
	INSERT INTO SLMSMessageArchiveTemp (SessionId, SLMSMessageId, TaskId)
	SELECT TOP 5000 @SessionId, Id, TaskId
	FROM SLMSMessage WITH (NOLOCK)
	WHERE CreatedOn <= @CutOffDateTime AND SentOn IS NOT NULL
	ORDER BY Id
	
	-- 'Archive SLMSMessage'
	INSERT INTO SLMSMessageArchive
	SELECT
		Id,
		TaskId,
		MessageStatus,
		MessageLocalId,
		MessageSPId,
		MobilePhone,
		Parameters,
		CreatedOn,
		SentOn,
		Comment,
		IsTracked
	FROM SLMSMessage WITH (NOLOCK)
	WHERE Id IN (SELECT SLMSMessageId FROM SLMSMessageArchiveTemp WHERE SessionId = @SessionId)
	
	-- 'Archive SLMSMessageActionLog'
	INSERT INTO SLMSMessageActionLogArchive
	SELECT
		Id,
		MessageId,
		ActionType,
		ActionResult,
		Operator,
		ActionStartDate,
		ActionStartTime,
		ActionStartDateTime,
		ActionEndDate,
		ActionEndTime,
		ActionEndDateTime,
		Comment
	FROM SLMSMessageActionLog WITH (NOLOCK)
	WHERE MessageId IN (SELECT SLMSMessageId FROM SLMSMessageArchiveTemp WHERE SessionId = @SessionId)
	
	-- 'Archive Task'
	INSERT INTO TaskArchive
	SELECT
		Id,
		ConsumerId,
		ServiceProviderId,
		TaskPriority,
		TaskStatus,
		MessageType,
		EmailTemplateId,
		SLMSTemplateId,
		MMSTemplateId,
		TaskLocalId,
		ScheduledDate,
		ScheduledTime,
		ScheduledDateTime,
		TimezoneOffset,
		CreatedOn,
		ProcessedOn,
		MessageNumber,
		TriedCount,
		Comment
	FROM Task WITH (NOLOCK)
	WHERE Id IN (SELECT TaskId FROM SLMSMessageArchiveTemp WHERE SessionId = @SessionId)
	
	-- 'Archive TaskActionLog'
	INSERT INTO TaskActionLogArchive
	SELECT
		Id,
		TaskId,
		ActionType,
		ActionResult,
		Operator,
		ActionStartDate,
		ActionStartTime,
		ActionStartDateTime,
		ActionEndDate,
		ActionEndTime,
		ActionEndDateTime,
		Comment
	FROM TaskActionLog WITH (NOLOCK)
	WHERE TaskId IN (SELECT TaskId FROM SLMSMessageArchiveTemp WHERE SessionId = @SessionId)
	
	-- 'Archive SLMSMessageTemplate'
	DECLARE @SLMSMessageTemplateIdList TABLE (Id BIGINT)
	
	INSERT INTO @SLMSMessageTemplateIdList
	SELECT DISTINCT SLMSTemplateId
	FROM Task WITH (NOLOCK)
	WHERE Id IN (SELECT TaskId FROM SLMSMessageArchiveTemp WHERE SessionId = @SessionId)
	
	INSERT INTO SLMSMessageTemplateArchive
	SELECT Id, Content
	FROM SLMSMessageTemplate WITH (NOLOCK)
	WHERE Id IN (SELECT Id FROM @SLMSMessageTemplateIdList)
	
	-- 'Delete SLMSMessageActionLog'
	DELETE SLMSMessageActionLog
	WHERE MessageId IN (SELECT SLMSMessageId FROM SLMSMessageArchiveTemp WHERE SessionId = @SessionId)
	
	-- 'Delete SLMSMessage'
	DELETE SLMSMessage
	WHERE Id IN (SELECT SLMSMessageId FROM SLMSMessageArchiveTemp WHERE SessionId = @SessionId)
	
	-- 'Delete TaskActionLog'
	DELETE TaskActionLog
	WHERE TaskId IN (SELECT TaskId FROM SLMSMessageArchiveTemp WHERE SessionId = @SessionId)
	
	-- 'Delete Task'
	DELETE Task
	WHERE Id IN (SELECT TaskId FROM SLMSMessageArchiveTemp WHERE SessionId = @SessionId)
	AND Id NOT IN (SELECT TaskId FROM SLMSMessage WITH (NOLOCK))
	
	-- 'Delete SLMSMessageTemplate'
	DELETE SLMSMessageTemplate
	WHERE Id IN (SELECT Id FROM @SLMSMessageTemplateIdList)
	AND Id NOT IN (SELECT SLMSTemplateId FROM Task WITH (NOLOCK) WHERE SLMSTemplateId IS NOT NULL)
	
END TRY
BEGIN CATCH
	SELECT @ErrorMessage = ERROR_MESSAGE()
	SELECT @ErrorLine = ERROR_LINE()

	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
END CATCH;

IF @@TRANCOUNT > 0
	COMMIT TRANSACTION;

END

