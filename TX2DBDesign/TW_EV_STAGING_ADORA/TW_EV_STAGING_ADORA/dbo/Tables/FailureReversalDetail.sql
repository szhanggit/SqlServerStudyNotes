CREATE TABLE [dbo].[FailureReversalDetail] (
    [Id]                         BIGINT       IDENTITY (1, 1) NOT NULL,
    [MultiAccountsTransactionId] BIGINT       NOT NULL,
    [TerminalSSNRef]             VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_FailureReversalDetail_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_FailureReversalDetail_MultiAccountsTransaction_MultiAccountsTransactionId] FOREIGN KEY ([MultiAccountsTransactionId]) REFERENCES [dbo].[MultiAccountsTransaction] ([Id]),
    CONSTRAINT [UK_FailureReversalDetail] UNIQUE NONCLUSTERED ([MultiAccountsTransactionId] ASC, [TerminalSSNRef] ASC)
);

