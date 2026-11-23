CREATE TABLE [dbo].[DeletedVoucherActionHistory] (
    [Id]                       INT             IDENTITY (1, 1) NOT NULL,
    [VoucherActionHistoryId]   BIGINT          NULL,
    [VoucherId]                BIGINT          NULL,
    [ActionType]               SMALLINT        NULL,
    [ActionResult]             TINYINT         NULL,
    [Operator]                 NVARCHAR (50)   NULL,
    [ActionTime]               DATETIME        NULL,
    [Memo]                     NVARCHAR (1000) NULL,
    [BatchTransactionDetailId] INT             NOT NULL,
    [SessionId]                VARCHAR (100)   NULL,
    [BackupOn]                 DATETIME        NULL,
    [Channel]                  VARCHAR (100)   NULL,
    [Comment]                  VARCHAR (1000)  NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

