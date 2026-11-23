CREATE TABLE [dbo].[EmailMessageArchiveBuffer] (
    [Id]             BIGINT          NOT NULL,
    [TaskId]         BIGINT          NOT NULL,
    [MessageStatus]  INT             NULL,
    [MessageLocalId] BIGINT          NOT NULL,
    [MessageSPId]    NVARCHAR (100)  NULL,
    [To]             NVARCHAR (1000) NOT NULL,
    [CC]             NVARCHAR (1000) NULL,
    [BCC]            NVARCHAR (1000) NULL,
    [Parameters]     NVARCHAR (MAX)  NULL,
    [Attachments]    NVARCHAR (1000) NULL,
    [CreatedOn]      DATETIME        NULL,
    [SentOn]         DATETIME        NULL,
    [Comment]        NVARCHAR (500)  NULL,
    [IsTracked]      BIT             NOT NULL
);

