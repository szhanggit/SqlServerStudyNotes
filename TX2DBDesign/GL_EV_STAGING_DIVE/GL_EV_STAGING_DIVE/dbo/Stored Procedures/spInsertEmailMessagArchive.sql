

CREATE PROCEDURE spInsertEmailMessagArchive
	-- Add the parameters for the stored procedure here
			@Id bigint,
			@TaskId bigint,
			@MessageStatus int,
			@MessageLocalId bigint,
			@MessageSPId nvarchar(100),
			@To nvarchar(1000),
			@CC nvarchar(1000),
			@BCC nvarchar(1000),
			@Parameters nvarchar(max),
			@Attachments nvarchar(1000),
			@CreatedOn datetime,
			@SentOn datetime,
			@Comment nvarchar(500),
			@IsTracked bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[EmailMessageArchive]
           ([Id]
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
           ,[IsTracked])
     VALUES
           (@Id ,
			@TaskId,
			@MessageStatus ,
			@MessageLocalId,
			@MessageSPId ,
			@To,
			@CC,
			@BCC,
			@Parameters,
			@Attachments,
			@CreatedOn,
			@SentOn,
			@Comment,
			@IsTracked )

		Delete from [dbo].[EmailMessageArchiveBuffer] where id = @id
END
