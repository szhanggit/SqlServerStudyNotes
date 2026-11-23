CREATE TABLE [dbo].[ClearingDiff_History] (
    [Id]            BIGINT       NOT NULL,
    [ClearingId]    BIGINT       NOT NULL,
    [TerminalSSN]   VARCHAR (50) NOT NULL,
    [AccountNumber] VARCHAR (50) NOT NULL,
    [TranCode]      VARCHAR (50) NOT NULL,
    [ResponseCode]  VARCHAR (5)  NULL
) ON [DATA2];

