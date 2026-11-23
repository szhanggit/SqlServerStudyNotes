CREATE TYPE [dbo].[Account_Table_Type] AS TABLE (
    [AccountNumber] VARCHAR (50) NULL,
    [ProgramId]     INT          NULL,
    [Checksum]      VARCHAR (50) NULL,
    [TranCount]     INT          NULL,
    [ModifyVersion] INT          NULL,
    [Status]        INT          NULL,
    [LastTranOn]    DATETIME     NULL,
    [ActiveFrom]    DATETIME     NULL);

