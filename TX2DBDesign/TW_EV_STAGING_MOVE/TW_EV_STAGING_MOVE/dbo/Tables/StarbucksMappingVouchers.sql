CREATE TABLE [dbo].[StarbucksMappingVouchers] (
    [MasterOrderNumber] NVARCHAR (50)    NOT NULL,
    [MasterProductCode] NVARCHAR (20)    NOT NULL,
    [ChildOrderNumber]  NVARCHAR (50)    NOT NULL,
    [ChildProductCode]  NVARCHAR (20)    NOT NULL,
    [MasterVoucherGuid] UNIQUEIDENTIFIER NOT NULL,
    [ChildVoucherGuid]  UNIQUEIDENTIFIER NOT NULL
);

