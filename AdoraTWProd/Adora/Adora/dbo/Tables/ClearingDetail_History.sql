CREATE TABLE [dbo].[ClearingDetail_History] (
    [Id]            BIGINT       NOT NULL,
    [ClearingId]    BIGINT       NOT NULL,
    [TerminalSSN]   VARCHAR (50) NOT NULL,
    [AccountNumber] VARCHAR (50) NOT NULL,
    [TranCode]      VARCHAR (50) NOT NULL
) ON [DATA2];

