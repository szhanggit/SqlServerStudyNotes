CREATE TABLE [dbo].[VoucherBuffer] (
    [Id]            INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [LocalId]       INT           NULL,
    [VoucherNumber] VARCHAR (100) NULL,
    [ProgramId]     INT           NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

