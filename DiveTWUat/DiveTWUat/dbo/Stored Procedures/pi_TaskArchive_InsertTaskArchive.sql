CREATE  PROCEDURE [dbo].[pi_TaskArchive_InsertTaskArchive]
  @Days	int,
  @exception  varchar(20) output  
AS
BEGIN 

 DECLARE @TaskTemp TABLE
	(
	Id bigint , 
	MessageType int ,
	EmailTemplateId bigint ,
	SLMSTemplateId bigint
	)
DECLARE @Id bigint                   
DECLARE @MessageType int          
DECLARE @EmailTemplateId bigint  
DECLARE @SLMSTemplateId bigint
DECLARE @errorcode int

--insert @TaskTemp
INSERT INTO @TaskTemp
SELECT Id,MessageType,EmailTemplateId,SLMSTemplateId
FROM Task 
WHERE  DATEDIFF (DAY,ProcessedOn, GETUTCDATE())>= @Days
	AND TaskStatus in (3,4,5,6)
--3=Sent Success
--4=Sent Failed
--5=Sent Partly Success
--6=Trashed


--declare Task_cursor
DECLARE Task_cursor CURSOR FOR
	SELECT * FROM @TaskTemp
	    select @errorcode = @@ERROR
		IF (@errorcode <> 0)
		begin
			select @exception = CONVERT(varchar(15),@errorcode) + '=' + '01'
			return
		end
OPEN Task_cursor;
		select @errorcode = @@ERROR
		IF (@errorcode <> 0)
		begin
			select @exception = CONVERT(varchar(15),@errorcode) + '=' + '02'
			return
		end
FETCH NEXT FROM Task_cursor INTO @Id,@MessageType ,@EmailTemplateId ,@SLMSTemplateId 
	WHILE (@@FETCH_STATUS = 0)
		BEGIN
			BEGIN TRAN myTran
 				IF(@MessageType =1)
					BEGIN
					    --delete existed data from TArchive 
						DELETE t1 
						FROM EmailMessageActionLogArchive t1
						     join EmailMessage t2 on t1.MessageId = t2.id
						WHERE  t2.TaskId =@Id

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '03'
							goto ERROR_HANDLER
						end

						DELETE FROM EmailMessageArchive
						WHERE TaskId =@Id

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '04'
							goto ERROR_HANDLER
						end

						DELETE FROM TaskActionLogArchive
						WHERE TaskId =@Id

					    select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '05'
							goto ERROR_HANDLER
						end

						DELETE FROM TaskArchive
						WHERE Id=@Id

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '06'
							goto ERROR_HANDLER
						end

						DELETE FROM EmailMessageTemplateArchive
						WHERE Id=@EmailTemplateId
						
						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '07'
							goto ERROR_HANDLER
						end

						--Insert TArchive
						INSERT INTO EmailMessageTemplateArchive            
						SELECT Id,[Subject],Body,BodyFormat,Sender,SenderDisplayName
						FROM EmailMessageTemplate 
						WHERE Id=@EmailTemplateId
			
						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '08'
							goto ERROR_HANDLER
						end

						INSERT INTO TaskArchive
						SELECT  Id,
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
						FROM Task   
						WHERE Id=@Id

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '09'
							goto ERROR_HANDLER
						end

						INSERT INTO TaskActionLogArchive
						SELECT  Id,
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
						FROM TaskActionLog  
						WHERE  TaskId =@Id 

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '10'
							goto ERROR_HANDLER
						end

						INSERT INTO EmailMessageArchive
						SELECT  Id,
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
								Comment
						FROM EmailMessage  
						WHERE TaskId =@Id

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '11'
							goto ERROR_HANDLER
						end

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
						WHERE  t2.TaskId =@Id

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '12'
							goto ERROR_HANDLER
						end

						--delete from T
						DELETE t1 
						FROM EmailMessageActionLog t1
						     join EmailMessage t2 on t1.MessageId = t2.id
						WHERE  t2.TaskId =@Id

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '13'
							goto ERROR_HANDLER
						end

						DELETE FROM EmailMessage
						WHERE TaskId =@Id

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '14'
							goto ERROR_HANDLER
						end

						DELETE FROM TaskActionLog
						WHERE TaskId =@Id

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '15'
							goto ERROR_HANDLER
						end

						DELETE FROM Task
						WHERE Id=@Id

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '16'
							goto ERROR_HANDLER
						end

						DELETE FROM EmailMessageTemplate
						WHERE Id=@EmailTemplateId

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '17'
							goto ERROR_HANDLER
						end
					END
				ELSE 
					BEGIN

						--delete from TArchive 
						DELETE t1 FROM SLMSMessageActionLogArchive t1
						     join SLMSMessage t2 on t1.MessageId = t2.id
						WHERE  t2.TaskId =@Id

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '18'
							goto ERROR_HANDLER
						end

						DELETE FROM SLMSMessageArchive
						WHERE TaskId =@Id

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '19'
							goto ERROR_HANDLER
						end

						DELETE FROM TaskActionLogArchive
						WHERE TaskId =@Id

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '20'
							goto ERROR_HANDLER
						end

						DELETE FROM TaskArchive
						WHERE Id=@Id

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '21'
							goto ERROR_HANDLER
						end

						DELETE FROM SLMSMessageTemplateArchive
						WHERE Id=@SLMSTemplateId

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '22'
							goto ERROR_HANDLER
						end

						--Insert TArchive
						INSERT INTO SLMSMessageTemplateArchive 
						SELECT Id,Content
						FROM SLMSMessageTemplate 
						WHERE Id=@SLMSTemplateId
						
						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '23'
							goto ERROR_HANDLER
						end

						INSERT INTO TaskArchive
						SELECT  Id,
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
						FROM Task    
						WHERE Id=@Id

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '24'
							goto ERROR_HANDLER
						end

						INSERT INTO TaskActionLogArchive
						SELECT	Id,
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
						FROM TaskActionLog   
						WHERE  TaskId =@Id 

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '25'
							goto ERROR_HANDLER
						end

						INSERT INTO SLMSMessageArchive
						SELECT	Id,
								TaskId,
								MessageStatus,
								MessageLocalId,
								MessageSPId,
								MobilePhone,
								Parameters,
								CreatedOn,
								SentOn,
								Comment 
						FROM SLMSMessage  
						WHERE TaskId =@Id

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '26'
							goto ERROR_HANDLER
						end

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
						WHERE  t2.TaskId =@Id

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '27'
							goto ERROR_HANDLER
						end

						--delete from T
						DELETE t1 FROM SLMSMessageActionLog t1
						     join SLMSMessage t2 on t1.MessageId = t2.id
						WHERE  t2.TaskId =@Id

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '28'
							goto ERROR_HANDLER
						end

						DELETE FROM SLMSMessage
						WHERE TaskId =@Id

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '29'
							goto ERROR_HANDLER
						end

						DELETE FROM TaskActionLog
						WHERE TaskId =@Id

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '30'
							goto ERROR_HANDLER
						end

						DELETE FROM Task
						WHERE Id=@Id

						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '31'
							goto ERROR_HANDLER
						end

						DELETE FROM SLMSMessageTemplate
						WHERE Id=@SLMSTemplateId
						select @errorcode = @@ERROR
						IF (@errorcode <> 0)
						begin
							select @exception = CONVERT(varchar(15),@errorcode) + '=' + '32'
							goto ERROR_HANDLER
						end
					END

			COMMIT TRAN myTran
			FETCH NEXT FROM Task_cursor INTO @Id,@MessageType ,@EmailTemplateId ,@SLMSTemplateId 
			continue;

			ERROR_HANDLER:
			rollback tran mytran
			CLOSE Task_cursor
            DEALLOCATE Task_cursor
			return
		END
CLOSE Task_cursor
DEALLOCATE Task_cursor

END
