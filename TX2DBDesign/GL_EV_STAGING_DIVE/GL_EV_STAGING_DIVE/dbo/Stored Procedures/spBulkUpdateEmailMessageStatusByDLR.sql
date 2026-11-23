
CREATE PROCEDURE [dbo].[spBulkUpdateEmailMessageStatusByDLR]
@UpdatedTable TablePrimaryIdType READONLY,
@IsSuccess bit output
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE T1 SET T1.[MessageStatus] = T2.SendStatus FROM [dbo].[EmailMessage] AS T1
					JOIN EmailMessageSendStatus AS T2 ON T1.[MessageSPId] = T2.[MessageId]
															 AND T2.SendStatus = 3
					INNER JOIN @UpdatedTable ut ON T2.Id = ut.Id
					WHERE T1.[MessageStatus] in(2,4);
					
	DELETE emss FROM EmailMessageSendStatus emss INNER JOIN @UpdatedTable ut ON emss.Id = ut.Id;
	set @IsSuccess = 1;
END;
