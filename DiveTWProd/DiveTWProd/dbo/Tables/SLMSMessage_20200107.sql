CREATE TABLE [dbo].[SLMSMessage_20200107] (
    [Id]             BIGINT          IDENTITY (1, 1) NOT NULL,
    [TaskId]         BIGINT          NOT NULL,
    [MessageStatus]  INT             NULL,
    [MessageLocalId] BIGINT          NOT NULL,
    [MessageSPId]    NVARCHAR (100)  NULL,
    [MobilePhone]    NVARCHAR (20)   NOT NULL,
    [Parameters]     NVARCHAR (2000) NULL,
    [CreatedOn]      DATETIME        NULL,
    [SentOn]         DATETIME        NULL,
    [Comment]        NVARCHAR (500)  NULL
);

