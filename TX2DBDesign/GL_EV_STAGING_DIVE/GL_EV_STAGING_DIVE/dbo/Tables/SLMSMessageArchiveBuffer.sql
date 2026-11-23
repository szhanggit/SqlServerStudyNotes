CREATE TABLE [dbo].[SLMSMessageArchiveBuffer] (
    [Id]             BIGINT         NOT NULL,
    [TaskId]         BIGINT         NOT NULL,
    [MessageStatus]  INT            NULL,
    [MessageLocalId] BIGINT         NOT NULL,
    [MessageSPId]    NVARCHAR (50)  NULL,
    [MobilePhone]    NVARCHAR (20)  NOT NULL,
    [Parameters]     NVARCHAR (MAX) NULL,
    [CreatedOn]      DATETIME       NULL,
    [SentOn]         DATETIME       NULL,
    [Comment]        NVARCHAR (500) NULL,
    [IsTracked]      BIT            NOT NULL
);

