CREATE TABLE [dbo].[VoucherUpdateBuffer] (
    [Id]            BIGINT        IDENTITY (1, 1) NOT NULL,
    [ProgramId]     INT           NOT NULL,
    [VoucherNumber] VARCHAR (100) NOT NULL,
    [TaskId]        VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200727-103456]
    ON [dbo].[VoucherUpdateBuffer]([VoucherNumber] ASC, [ProgramId] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200727-103705]
    ON [dbo].[VoucherUpdateBuffer]([TaskId] ASC);

