
CREATE   PROCEDURE [spGetAllSLMSMessageArchiveBuffer]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/****** Script for SelectTopNRows command from SSMS  ******/
SELECT top 10000 [Id]
      ,[TaskId]
      ,[MessageStatus]
      ,[MessageLocalId]
      ,[MessageSPId]
      ,[MobilePhone]
      ,[Parameters]
      ,[CreatedOn]
      ,[SentOn]
      ,[Comment]
      ,[IsTracked]
  FROM [dbo].[SLMSMessageArchiveBuffer] with (nolock)
    order by id asc
END
