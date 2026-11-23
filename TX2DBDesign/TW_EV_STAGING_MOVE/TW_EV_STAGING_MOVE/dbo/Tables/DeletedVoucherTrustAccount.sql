CREATE TABLE [dbo].[DeletedVoucherTrustAccount] (
    [Id]                           INT             IDENTITY (1, 1) NOT NULL,
    [DeletedVoucherTrustAccountId] BIGINT          NULL,
    [TrustAccountId]               INT             NULL,
    [TrustAmountOption]            INT             NULL,
    [TrustAccountBatchNo]          NVARCHAR (200)  NULL,
    [Amount]                       NUMERIC (20, 6) NULL,
    [ExpiryPolicyId]               INT             NULL,
    [ExpiryDate]                   DATETIME        NULL,
    [BatchTransactionDetailId]     INT             NOT NULL,
    [SessionId]                    VARCHAR (100)   NULL,
    [BackupOn]                     DATETIME        NULL,
    [Channel]                      VARCHAR (100)   NULL,
    [Comment]                      VARCHAR (1000)  NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

