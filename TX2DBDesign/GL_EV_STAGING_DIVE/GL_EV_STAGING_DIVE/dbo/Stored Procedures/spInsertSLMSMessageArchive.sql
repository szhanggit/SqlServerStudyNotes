
CREATE PROCEDURE spInsertSLMSMessageArchive
	@id bigint,
	@TaskID bigint,
	@MessageStatus int,
	@MessageLocalId bigint,
	@MessageSPId nvarchar(50),
	@MobilePhone nvarchar(20),
	@Parameters  nvarchar(1000),
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
	INSERT INTO [dbo].[SLMSMessageArchive]
           ([Id]
           ,[TaskId]
           ,[MessageStatus]
           ,[MessageLocalId]
           ,[MessageSPId]
           ,[MobilePhone]
           ,[Parameters]
           ,[CreatedOn]
           ,[SentOn]
           ,[Comment]
           ,[IsTracked])
     VALUES
           (@id,
           @TaskId,
           @MessageStatus,
           @MessageLocalId, 
           @MessageSPId, 
           @MobilePhone, 
           @Parameters,
           @CreatedOn, 
           @SentOn, 
           @Comment, 
           @IsTracked)

		   Delete from [dbo].[SLMSMessageArchiveBuffer] where id = @id
END
