CREATE TABLE [dbo].[VoucherUpdateBuffer] (
    [Id]            BIGINT        IDENTITY (1, 1) NOT NULL,
    [ProgramId]     INT           NOT NULL,
    [VoucherNumber] VARCHAR (100) NOT NULL,
    [TaskId]        VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

