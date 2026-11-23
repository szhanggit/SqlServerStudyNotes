CREATE TABLE [dbo].[AccountToGenReverseActivatePreIssuedTran] (
    [AccountNumber] VARCHAR (50) NOT NULL,
    [ProgramCode]   VARCHAR (20) NOT NULL,
    [CreatedOn]     DATETIME     NOT NULL,
    [Amount]        INT          NOT NULL,
    [ProcessCode]   VARCHAR (50) NULL,
    [ProcessedOn]   DATETIME     NULL,
    CONSTRAINT [PK_AccountToGenReverseActivatePreIssuedTran_AccountNumber_ProgramCode] PRIMARY KEY NONCLUSTERED ([AccountNumber] ASC, [ProgramCode] ASC) WITH (FILLFACTOR = 90)
);

