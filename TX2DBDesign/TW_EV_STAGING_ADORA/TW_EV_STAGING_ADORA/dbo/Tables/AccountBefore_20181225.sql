CREATE TABLE [dbo].[AccountBefore_20181225] (
    [VoucherNumber] VARCHAR (50) NOT NULL,
    [ProgramId]     INT          NOT NULL,
    [IdentityCode]  VARCHAR (20) NOT NULL,
    [Id]            INT          IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_YourTable] PRIMARY KEY CLUSTERED ([Id] ASC)
);

