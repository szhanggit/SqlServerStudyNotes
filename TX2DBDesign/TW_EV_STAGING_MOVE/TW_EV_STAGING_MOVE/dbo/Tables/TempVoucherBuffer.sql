CREATE TABLE [dbo].[TempVoucherBuffer] (
    [VoucherNumber] VARCHAR (100) NULL,
    [ProgramId]     INT           NULL,
    [SessionId]     VARCHAR (100) NULL,
    [TaskId]        VARCHAR (100) NULL
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex_TempVoucherBuffer_TaskId]
    ON [dbo].[TempVoucherBuffer]([TaskId] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex_TempVoucherBuffer_SessionId]
    ON [dbo].[TempVoucherBuffer]([SessionId] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex_TempVoucherBuffer_ProgramId_VoucherNumber]
    ON [dbo].[TempVoucherBuffer]([ProgramId] ASC, [VoucherNumber] ASC);

