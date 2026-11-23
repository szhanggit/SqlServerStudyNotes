CREATE TABLE [dbo].[ProcessLog] (
    [Id]             INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OrderGroupId]   INT           NOT NULL,
    [LogFileName]    VARCHAR (40)  NULL,
    [SessionId]      VARCHAR (50)  NOT NULL,
    [CreateTime]     SMALLDATETIME NULL,
    [FileCreateTime] SMALLDATETIME NULL,
    [FileType]       INT           NULL,
    [NeedCreateFile] BIT           NULL,
    [SendFailMail]   BIT           NULL,
    CONSTRAINT [PK_ProcessLog_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [index_ProcessLog_OrderGroupId]
    ON [dbo].[ProcessLog]([OrderGroupId] ASC);

