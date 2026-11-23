CREATE TABLE [dbo].[FailureReversalDetail] (
    [Id]                         BIGINT       IDENTITY (1, 1) NOT NULL,
    [MultiAccountsTransactionId] BIGINT       NOT NULL,
    [TerminalSSNRef]             VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_FailureReversalDetail_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_FailureReversalDetail_MultiAccountsTransaction_MultiAccountsTransactionId] FOREIGN KEY ([MultiAccountsTransactionId]) REFERENCES [dbo].[MultiAccountsTransaction] ([Id]),
    CONSTRAINT [UK_FailureReversalDetail] UNIQUE NONCLUSTERED ([MultiAccountsTransactionId] ASC, [TerminalSSNRef] ASC) WITH (FILLFACTOR = 90)
);

