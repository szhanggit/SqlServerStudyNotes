
CREATE PROCEDURE [dbo].[spGetEmailMessageStatusDTO]
@SelectedTable TablePrimaryIdType READONLY,
@Country nvarchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT  em.Id as MessageId ,
            em.MessageLocalId as DistributionTaskMessageId ,
            esb.SendStatus ,
            esb.OriginalStatus ,
            esb.[Description],
            esb.OriginalTime
    FROM    dbo.EmailMessageSendStatus esb with(NOLOCK)
	INNER JOIN @SelectedTable st ON st.Id = esb.Id
    LEFT JOIN dbo.EmailMessage em with(nolock) ON esb.MessageId = em.MessageSPId 
    WHERE esb.Country=@Country
    AND em.SentOn IS NOT NULL
    AND em.SentOn BETWEEN dateadd(dd,-30,getutcdate()) AND dateadd(hh,1,getutcdate());
END;
