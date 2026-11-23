CREATE TABLE [dbo].[AccountToGenTran] (
    [AccountNumber] VARCHAR (50) NOT NULL,
    [ProgramCode]   VARCHAR (20) NOT NULL,
    [CreatedOn]     DATETIME     NOT NULL,
    [Amount]        INT          NOT NULL,
    [ProcessCode]   VARCHAR (50) NULL,
    [ProcessedOn]   DATETIME     NULL,
    CONSTRAINT [PK_AccountToGenTran_AccountNumber_ProgramCode] PRIMARY KEY NONCLUSTERED ([AccountNumber] ASC, [ProgramCode] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_AccountToGenTran_ProcessCode]
    ON [dbo].[AccountToGenTran]([ProcessCode] ASC);

