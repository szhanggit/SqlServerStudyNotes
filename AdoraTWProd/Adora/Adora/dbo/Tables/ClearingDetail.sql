CREATE TABLE [dbo].[ClearingDetail] (
    [Id]            BIGINT       IDENTITY (1, 1) NOT NULL,
    [ClearingId]    BIGINT       NOT NULL,
    [TerminalSSN]   VARCHAR (50) NOT NULL,
    [AccountNumber] VARCHAR (50) NOT NULL,
    [TranCode]      VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_ClearingDetail_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ClearingDetail_Clearing_ClearingId] FOREIGN KEY ([ClearingId]) REFERENCES [dbo].[Clearing] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IDX_ClearingDetail_TerminalSSN]
    ON [dbo].[ClearingDetail]([TerminalSSN] ASC) WITH (FILLFACTOR = 90);

