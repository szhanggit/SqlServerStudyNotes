CREATE TABLE [dbo].[AccountBefore_20181225] (
    [VoucherNumber] VARCHAR (50) NULL,
    [ProgramId]     INT          NULL,
    [IdentityCode]  VARCHAR (20) NOT NULL,
    [Id]            INT          IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_YourTable] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

