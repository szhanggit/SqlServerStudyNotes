
CREATE PROCEDURE [dbo].[spBulkUpdateMessageIsTrackedByDLR]
@messageType int,
@UpdatedTable TableMessageSPIdType READONLY,
@IsSuccess bit output
AS
BEGIN
    SET NOCOUNT ON;
    
	if @messageType = 1
	BEGIN
		UPDATE T1 SET T1.[IsTracked] = 1 FROM [dbo].[EmailMessage] AS T1 WITH(NOLOCK)
					INNER JOIN @UpdatedTable ut ON T1.MessageSPId = ut.MessageSPId
	END
				
	if @messageType = 2
	BEGIN
		UPDATE T1 SET T1.[IsTracked] = 1 FROM [dbo].[SLMSMessage] AS T1 WITH(NOLOCK)
					INNER JOIN @UpdatedTable ut ON T1.MessageSPId = ut.MessageSPId
	END
	set @IsSuccess = 1;
END;
