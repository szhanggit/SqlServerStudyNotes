

CREATE   PROCEDURE spGetAllEmailMessageArchiveBuffer
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT top 10000 [Id]
      ,[TaskId]
      ,[MessageStatus]
      ,[MessageLocalId]
      ,[MessageSPId]
      ,[To]
      ,[CC]
      ,[BCC]
      ,[Parameters]
      ,[Attachments]
      ,[CreatedOn]
      ,[SentOn]
      ,[Comment]
      ,[IsTracked]
  FROM [dbo].[EmailMessageArchiveBuffer] with (nolock)
  order by id asc
  
END
