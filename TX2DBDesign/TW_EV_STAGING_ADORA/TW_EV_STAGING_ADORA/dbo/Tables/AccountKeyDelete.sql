CREATE TABLE [dbo].[AccountKeyDelete] (
    [Id]                               INT            IDENTITY (1, 1) NOT NULL,
    [AccountNumber]                    VARCHAR (50)   NULL,
    [ProgramId]                        INT            NULL,
    [BatchTransactionDetailId]         INT            NOT NULL,
    [BatchTransactionDetailExternalId] INT            NOT NULL,
    [SessionId]                        VARCHAR (100)  NULL,
    [BackupOn]                         DATETIME       NULL,
    [Channel]                          VARCHAR (100)  NULL,
    [Comment]                          VARCHAR (1000) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

