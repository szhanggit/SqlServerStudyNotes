
CREATE  PROCEDURE [dbo].[pi_TaskArchive_InsertTaskArchive]
   @Days	int
  ,@ErrorMessage			nvarchar(4000)	OUTPUT 
  ,@ErrorLine				int				OUTPUT
AS
BEGIN 

 BEGIN TRAN

	BEGIN TRY
		 DECLARE @TaskTemp TABLE
			(
			Id bigint , 
			MessageType int ,
			EmailTemplateId bigint ,
			SLMSTemplateId bigint
			)

		Declare @ArchiveTill as datetime

		select @ArchiveTill = DATEADD(day,-1*@Days,GETUTCDATE())

		--insert @TaskTemp
		INSERT INTO @TaskTemp
		SELECT Id,MessageType,EmailTemplateId,SLMSTemplateId
		FROM Task 
		WHERE  ProcessedOn<= @ArchiveTill
			AND TaskStatus in (3,4,5,6)
		--3=Sent Success --4=Sent Failed --5=Sent Partly Success --6=Trashed

		--Insert TArchive
		INSERT INTO EmailMessageTemplateArchive            
		SELECT t.Id,t.[Subject],t.Body,t.BodyFormat,t.Sender,t.SenderDisplayName
		FROM EmailMessageTemplate t
			join @TaskTemp t1 on t1.EmailTemplateId = t.Id
			left join EmailMessageTemplateArchive t2 on t.Id = t2.Id
		where t2.Id is null

		INSERT INTO SLMSMessageTemplateArchive 
		SELECT t.Id, t.Content
		FROM SLMSMessageTemplate t
			join @TaskTemp t1 on t.Id = t1.SLMSTemplateId
			left join SLMSMessageTemplateArchive t2 on t.id = t2.Id
		where t2.Id is null


		INSERT INTO TaskArchive
		SELECT  t.Id,
				t.ConsumerId,
				t.ServiceProviderId,
				t.TaskPriority,
				t.TaskStatus,
				t.MessageType,
				t.EmailTemplateId,
				t.SLMSTemplateId,
				t.MMSTemplateId,
				t.TaskLocalId,
				t.ScheduledDate,
				t.ScheduledTime,
				t.ScheduledDateTime,
				t.TimezoneOffset,
				t.CreatedOn,
				t.ProcessedOn,
				t.MessageNumber,
				t.TriedCount,
				t.Comment 
		FROM Task t 
			 join @TaskTemp t1 on t.Id = t1.Id
			 left join TaskArchive t2 on t.Id = t2.Id
		where t2.Id is null

		INSERT INTO TaskActionLogArchive
		SELECT  t.Id,
				t.TaskId,
				t.ActionType,
				t.ActionResult,
				t.Operator,
				t.ActionStartDate,
				t.ActionStartTime,
				t.ActionStartDateTime,
				t.ActionEndDate,
				t.ActionEndTime,
				t.ActionEndDateTime,
				t.Comment 
		FROM TaskActionLog t
			join @TaskTemp t1 on t.TaskId = t1.Id
			left join  TaskActionLogArchive t2 on t.id = t2.Id
        where t2.Id is null

		INSERT INTO EmailMessageArchive
		SELECT  t.Id,
				t.TaskId,
				t.MessageStatus,
				t.MessageLocalId,
				t.MessageSPId,
				t.[To],
				t.CC,
				t.BCC,
				t.Parameters,
				t.Attachments,
				t.CreatedOn,
				t.SentOn,
				t.Comment
		FROM EmailMessage t
			join @TaskTemp t1 on t.TaskId = t1.Id
			left join EmailMessageArchive t2 on t.Id = t2.Id
        where t2.Id is null

		INSERT INTO SLMSMessageArchive
		SELECT	t.Id,
				t.TaskId,
				t.MessageStatus,
				t.MessageLocalId,
				t.MessageSPId,
				t.MobilePhone,
				t.Parameters,
				t.CreatedOn,
				t.SentOn,
				t.Comment 
		FROM SLMSMessage t
			 join @TaskTemp t1 on t.TaskId = t1.Id
			left join SLMSMessageArchive t2 on t.Id = t2.Id
        where t2.Id is null


		INSERT INTO EmailMessageActionLogArchive
		SELECT  t1.Id,
				t1.MessageId,
				t1.ActionType,
				t1.ActionResult,
				t1.Operator,
				t1.ActionStartDate,
				t1.ActionStartTime,
				t1.ActionStartDateTime,
				t1.ActionEndDate,
				t1.ActionEndTime,
				t1.ActionEndDateTime,
				t1.Comment 
		FROM EmailMessageActionLog t1
				join EmailMessage t2 on t1.MessageId = t2.id
				join @TaskTemp t3 on t2.TaskId = t3.Id
				left join EmailMessageActionLogArchive t4 on t1.Id = t4.Id
        where t4.Id is null

		INSERT INTO SLMSMessageActionLogArchive
		SELECT	t1.Id,
				t1.MessageId,
				t1.ActionType,
				t1.ActionResult,
				t1.Operator,
				t1.ActionStartDate,
				t1.ActionStartTime,
				t1.ActionStartDateTime,
				t1.ActionEndDate,
				t1.ActionEndTime,
				t1.ActionEndDateTime,
				t1.Comment 
		FROM SLMSMessageActionLog t1
				join SLMSMessage t2 on t1.MessageId = t2.id
				join @TaskTemp t3 on t2.TaskId = t3.Id
				left join SLMSMessageActionLogArchive t4 on t1.Id = t4.Id
		where t4.id is null

		--Delete Original Table
		DELETE t1 
		FROM EmailMessageActionLog t1
				join EmailMessage t2 on t1.MessageId = t2.id
				join @TaskTemp t3 on t2.TaskId = t3.Id						

		DELETE t1 
		FROM SLMSMessageActionLog t1
				join SLMSMessage t2 on t1.MessageId = t2.id
				join @TaskTemp t3 on t2.TaskId = t3.Id

		DELETE t
		FROM EmailMessage t
			join @TaskTemp t1 on t.TaskId = t1.Id

		DELETE t
		FROM SLMSMessage t
				join @TaskTemp t1 on t.TaskId = t1.Id

		DELETE t 
		FROM TaskActionLog t
			join @TaskTemp t1 on t.TaskId = t1.Id

		DELETE t 
		FROM Task t
			join @TaskTemp t1 on t.Id = t1.Id

		DELETE t
		FROM EmailMessageTemplate t
			join @TaskTemp t1 on t1.EmailTemplateId = t.Id

		DELETE t
		FROM SLMSMessageTemplate t
				join @TaskTemp t1 on t.Id = t1.SLMSTemplateId
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

