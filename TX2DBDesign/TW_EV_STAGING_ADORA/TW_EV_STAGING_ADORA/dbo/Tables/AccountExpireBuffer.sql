CREATE TABLE [dbo].[AccountExpireBuffer] (
    [AccountNumber] VARCHAR (50) NOT NULL,
    [ProgramId]     INT          NOT NULL,
    [SessionId]     VARCHAR (50) NOT NULL,
    [Checksum]      VARCHAR (50) NOT NULL,
    [ModifyVersion] INT          NOT NULL,
    [LastTranOn]    DATETIME     NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IDX_AccountExpireBuffer_AccountNumber_ProgramId]
    ON [dbo].[AccountExpireBuffer]([AccountNumber] ASC, [ProgramId] ASC);

