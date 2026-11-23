
Create PROCEDURE [dbo].[pi_ArchiveEmailMessage]
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
	VALUES (1, @ArchiveDateTime, @CutOffDateTime, @SessionId)
	
	-- 'Insert EmailMesageArchiveTemp'
	INSERT INTO EmailMessageArchiveTemp (SessionId, EmailMessageId, TaskId)
	SELECT TOP 5000 @SessionId, Id, TaskId
	FROM EmailMessage WITH (NOLOCK)
	WHERE CreatedOn <= @CutOffDateTime AND SentOn IS NOT NULL
	ORDER BY Id
	
	-- 'Archive EmailMessage'
	INSERT INTO EmailMessageArchiveBuffer
	SELECT
		Id,
		TaskId,
		MessageStatus,
		MessageLocalId,
		MessageSPId,
		[To],
		CC,
		BCC,
		Parameters,
		Attachments,
		CreatedOn,
		SentOn,
		Comment,
		IsTracked
	FROM EmailMessage WITH (NOLOCK)
	WHERE Id IN (SELECT EmailMessageId FROM EmailMessageArchiveTemp WHERE SessionId = @SessionId)
	
	-- 'Archive EmailMessageActionLog'
	INSERT INTO EmailMessageActionLogArchive
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
	FROM EmailMessageActionLog WITH (NOLOCK)
	WHERE MessageId IN (SELECT EmailMessageId FROM EmailMessageArchiveTemp WHERE SessionId = @SessionId)
	
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
		Comment,
		IsBulk
	FROM Task WITH (NOLOCK)
	WHERE Id IN (SELECT TaskId FROM EmailMessageArchiveTemp WHERE SessionId = @SessionId)
	
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
	WHERE TaskId IN (SELECT TaskId FROM EmailMessageArchiveTemp WHERE SessionId = @SessionId)
	
	-- 'Archive EmailMessageTemplate'
	DECLARE @EmailMessageTemplateIdList TABLE (Id BIGINT)
	
	INSERT INTO @EmailMessageTemplateIdList
	SELECT DISTINCT EmailTemplateId
	FROM Task WITH (NOLOCK)
	WHERE Id IN (SELECT TaskId FROM EmailMessageArchiveTemp WHERE SessionId = @SessionId)
	
	INSERT INTO EmailMessageTemplateArchive
	SELECT Id, [Subject], Body, BodyFormat, Sender, SenderDisplayName
	FROM EmailMessageTemplate WITH (NOLOCK)
	WHERE Id IN (SELECT Id FROM @EmailMessageTemplateIdList)
	
	-- 'Delete EmailMessageActionLog'
	DELETE EmailMessageActionLog
	WHERE MessageId IN (SELECT EmailMessageId FROM EmailMessageArchiveTemp WHERE SessionId = @SessionId)
	
	-- 'Delete EmailMessage'
	DELETE EmailMessage
	WHERE Id IN (SELECT EmailMessageId FROM EmailMessageArchiveTemp WHERE SessionId = @SessionId)
	
	-- 'Delete TaskActionLog'
	DELETE TaskActionLog
	WHERE TaskId IN (SELECT TaskId FROM EmailMessageArchiveTemp WHERE SessionId = @SessionId)
	
	-- 'Delete Task'
	DELETE Task
	WHERE Id IN (SELECT TaskId FROM EmailMessageArchiveTemp WHERE SessionId = @SessionId)
	AND Id NOT IN (SELECT TaskId FROM EmailMessage WITH (NOLOCK))
	
	-- 'Delete EmailMessageTemplate'
	DELETE EmailMessageTemplate
	WHERE Id IN (SELECT Id FROM @EmailMessageTemplateIdList)
	AND Id NOT IN (SELECT EmailTemplateId FROM Task WITH (NOLOCK) WHERE EmailTemplateId IS NOT NULL)
	
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

IF EXISTS ( SELECT  1
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[spGetAllEmailMessageArchiveBuffer]')
                    AND OBJECTPROPERTY(id, N'IsProcedure') = 1 )
    DROP PROCEDURE [dbo].[spGetAllEmailMessageArchiveBuffer];
