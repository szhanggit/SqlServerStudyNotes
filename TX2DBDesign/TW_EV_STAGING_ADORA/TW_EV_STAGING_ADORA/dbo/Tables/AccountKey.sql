CREATE TABLE [dbo].[AccountKey] (
    [AccountNumber] VARCHAR (50) NOT NULL,
    [ProgramId]     INT          NOT NULL,
    CONSTRAINT [PK_AccountKey_AccountNumber_ProgramId] PRIMARY KEY CLUSTERED ([AccountNumber] ASC, [ProgramId] ASC)
);

