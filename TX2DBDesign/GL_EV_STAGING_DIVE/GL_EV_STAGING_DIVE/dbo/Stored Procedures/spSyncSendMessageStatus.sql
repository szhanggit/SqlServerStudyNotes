-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spSyncSendMessageStatus
	-- Add the parameters for the stored procedure here
    @SessionId UNIQUEIDENTIFIER ,
    @Channel NVARCHAR(50),
    @Country NVARCHAR(50)
AS
    DECLARE @NewSendStatusId INT= 0 ,
        @NewSendStatusBufferId INT= 0;

    IF @Channel = N'SMS'
        BEGIN
			--获得状态buffer表的最新记录Id
            SELECT TOP 1
                    @NewSendStatusBufferId = SLMSMessageSendStatusId
            FROM    SLMSMessageSendStatusBuffer WITH(NOLOCK)
			WHERE [Country] = @Country
            ORDER BY SLMSMessageSendStatusId DESC;

			--获得状态表的最新记录Id
            SELECT TOP 1
                    @NewSendStatusId = Id
            FROM    SLMSMessageSendStatus  WITH(NOLOCK)			
			WHERE [Country] = @Country
            ORDER BY Id DESC;

            BEGIN TRAN;
            IF ( @NewSendStatusId > @NewSendStatusBufferId )
                BEGIN
                    INSERT INTO SLMSMessageSendStatusBuffer
                            ( SlMSMessageSendStatusId ,
                              SessionId ,
                              MessageId ,
                              SendStatus ,
                              OriginalStatus ,
                              [Description] ,
                              CreatedTime,
							  [Country],
							  OriginalTime
                            )
                            SELECT TOP 200
                                    Id ,
                                    @SessionId ,
                                    MessageId ,
                                    SendStatus ,
                                    OriginalStatus ,
                                    [Description] ,
                                    GETDATE(),
									[Country],
							        OriginalTime
                            FROM    SLMSMessageSendStatus
                            WHERE   Id > @NewSendStatusBufferId ORDER BY id;
							
					UPDATE T1
					SET T1.[MessageStatus] = T2.SendStatus
					FROM [dbo].[SLMSMessage] AS T1
					JOIN SLMSMessageSendStatusBuffer AS T2 ON T1.[MessageSPId] = T2.[MessageId]
															 AND T2.SendStatus = 3
					WHERE T2.SessionId = @SessionId
					AND T1.[MessageStatus] != 3

					DELETE T1 FROM SLMSMessageSendStatus AS T1
					JOIN SLMSMessageSendStatusBuffer AS T2 ON T1.[Id] = T2.[SLMSMessageSendStatusId]
					WHERE T2.SessionId = @SessionId

					IF @Country <> 'IN'
						BEGIN
							DELETE  FROM dbo.SLMSMessageSendStatusBuffer
							WHERE   SessionId <> @SessionId
							AND [Country] = @Country
						END
                END;
            IF @@error <> 0
                BEGIN
                    ROLLBACK TRAN;
                END;
            COMMIT TRAN;

        END;
    ELSE
        BEGIN
			--获得状态buffer表的最新记录Id
            SELECT TOP 1
                    @NewSendStatusBufferId = EmailMessageSendStatusId
            FROM    EmailMessageSendStatusBuffer WITH(NOLOCK)			
			WHERE [Country] = @Country
            ORDER BY EmailMessageSendStatusId DESC;

			--获得状态表的最新记录Id
            SELECT TOP 1
                    @NewSendStatusId = Id
            FROM    EmailMessageSendStatus WITH(NOLOCK)			
			WHERE [Country] = @Country
            ORDER BY Id DESC;

            BEGIN TRAN;
            IF ( @NewSendStatusId > @NewSendStatusBufferId )
                BEGIN
                    INSERT  INTO EmailMessageSendStatusBuffer
                            ( EmailMessageSendStatusId ,
                              SessionId ,
                              MessageId ,
                              SendStatus ,
                              OriginalStatus ,
                              [Description] ,
                              CreatedTime,
							  [Country],
							  OriginalTime
                            )
                            SELECT TOP 200
                                    Id ,
                                    @SessionId ,
                                    MessageId ,
                                    SendStatus ,
                                    OriginalStatus ,
                                    [Description] ,
                                    GETDATE(),
									[Country],
							        OriginalTime
                            FROM    EmailMessageSendStatus
                            WHERE   Id > @NewSendStatusBufferId ORDER BY id;

					UPDATE T1
					SET T1.[MessageStatus] = T2.SendStatus
					FROM [dbo].[EmailMessage] AS T1
					JOIN EmailMessageSendStatusBuffer AS T2 ON T1.[MessageSPId] = T2.[MessageId]
															 AND T2.SendStatus = 3
					WHERE T2.SessionId = @SessionId
					AND T1.[MessageStatus] != 3
					
					DELETE T1 FROM EmailMessageSendStatus AS T1
					JOIN EmailMessageSendStatusBuffer AS T2 ON T1.[Id] = T2.[EmailMessageSendStatusId]
					WHERE T2.SessionId = @SessionId

                    IF @Country <> 'IN'
						BEGIN
							DELETE  FROM dbo.EmailMessageSendStatusBuffer
							WHERE   SessionId <> @SessionId					
							AND [Country] = @Country
						END
                END;
            IF @@error <> 0
                BEGIN
                    ROLLBACK TRAN;
                END;
            COMMIT TRAN;
        END;

