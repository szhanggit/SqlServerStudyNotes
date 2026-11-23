CREATE TABLE [dbo].[DeletedDistributionTaskMessage] (
    [Id]                               INT             IDENTITY (1, 1) NOT NULL,
    [DeletedDistributionTaskMessageId] BIGINT          NULL,
    [DistributionTaskId]               BIGINT          NULL,
    [VoucherId]                        BIGINT          NULL,
    [DistributionStatus]               TINYINT         NULL,
    [Memo]                             NVARCHAR (1000) NULL,
    [BatchTransactionDetailId]         INT             NOT NULL,
    [SessionId]                        VARCHAR (100)   NULL,
    [BackupOn]                         DATETIME        NULL,
    [Channel]                          VARCHAR (100)   NULL,
    [Comment]                          VARCHAR (1000)  NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

