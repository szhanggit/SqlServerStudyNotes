CREATE TABLE [dbo].[ClearingDiff] (
    [Id]            BIGINT       IDENTITY (1, 1) NOT NULL,
    [ClearingId]    BIGINT       NOT NULL,
    [TerminalSSN]   VARCHAR (50) NOT NULL,
    [AccountNumber] VARCHAR (50) NOT NULL,
    [TranCode]      VARCHAR (50) NOT NULL,
    [ResponseCode]  VARCHAR (5)  NULL,
    CONSTRAINT [PK_ClearingDiff_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ClearingDiff_Clearing_ClearingId] FOREIGN KEY ([ClearingId]) REFERENCES [dbo].[Clearing] ([Id])
);

