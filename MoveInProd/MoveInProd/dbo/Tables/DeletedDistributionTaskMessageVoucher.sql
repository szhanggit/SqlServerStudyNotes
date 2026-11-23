CREATE TABLE [dbo].[DeletedDistributionTaskMessageVoucher] (
    [Id]                                      INT            IDENTITY (1, 1) NOT NULL,
    [DeletedDistributionTaskMessageVoucherId] BIGINT         NULL,
    [DistributionTaskMessageId]               BIGINT         NULL,
    [VoucherId]                               BIGINT         NULL,
    [BatchTransactionDetailId]                INT            NOT NULL,
    [SessionId]                               VARCHAR (100)  NULL,
    [BackupOn]                                DATETIME       NULL,
    [Channel]                                 VARCHAR (100)  NULL,
    [Comment]                                 VARCHAR (1000) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

