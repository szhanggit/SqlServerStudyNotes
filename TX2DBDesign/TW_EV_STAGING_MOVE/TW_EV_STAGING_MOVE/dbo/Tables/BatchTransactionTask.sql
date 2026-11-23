CREATE TABLE [dbo].[BatchTransactionTask] (
    [Id]                  BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Status]              TINYINT       NOT NULL,
    [ExecuteStartTime]    DATETIME      NULL,
    [ExecuteEndTime]      DATETIME      NULL,
    [TotalVoucherCount]   INT           NOT NULL,
    [SuccessVoucherCount] INT           NULL,
    [FailVoucherCount]    INT           DEFAULT ((0)) NULL,
    [CreatedOn]           DATETIME      NOT NULL,
    [CreatedBy]           NVARCHAR (50) NOT NULL,
    [BatchTransactionId]  BIGINT        NOT NULL,
    CONSTRAINT [PK_BatchTransactionTask_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_BatchTransactionTask_BatchTransaction_BatchTransactionId] FOREIGN KEY ([BatchTransactionId]) REFERENCES [dbo].[BatchTransaction] ([Id])
);

