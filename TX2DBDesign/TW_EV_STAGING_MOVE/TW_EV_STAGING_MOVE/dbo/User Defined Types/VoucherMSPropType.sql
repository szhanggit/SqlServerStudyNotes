CREATE TYPE [dbo].[VoucherMSPropType] AS TABLE (
    [Id]            INT          NOT NULL,
    [VoucherNumber] VARCHAR (50) NOT NULL,
    [ProgramCode]   VARCHAR (20) NOT NULL,
    [OrderNumber]   VARCHAR (50) NOT NULL);

