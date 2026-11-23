CREATE TABLE [dbo].[VoucherTemp] (
    [UserName]      NVARCHAR (50) NOT NULL,
    [ProgramId]     INT           NOT NULL,
    [VoucherNumber] VARCHAR (50)  NOT NULL,
    CONSTRAINT [UK_VoucherTemp] UNIQUE NONCLUSTERED ([ProgramId] ASC, [VoucherNumber] ASC, [UserName] ASC)
);

