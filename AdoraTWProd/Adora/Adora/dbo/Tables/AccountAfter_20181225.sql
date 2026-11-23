CREATE TABLE [dbo].[AccountAfter_20181225] (
    [VoucherNumber] VARCHAR (50) NOT NULL,
    [ProgramId]     INT          NOT NULL,
    [ProgramCode]   VARCHAR (20) NOT NULL,
    [Id]            INT          IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_AccountAfter_20181225] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

