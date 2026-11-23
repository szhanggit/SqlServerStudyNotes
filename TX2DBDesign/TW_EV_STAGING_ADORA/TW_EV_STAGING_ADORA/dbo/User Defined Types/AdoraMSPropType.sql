CREATE TYPE [dbo].[AdoraMSPropType] AS TABLE (
    [Id]                       INT          NULL,
    [ProcessId]                INT          NULL,
    [VoucherNumber]            VARCHAR (50) NULL,
    [ProgramCode]              VARCHAR (50) NULL,
    [OrderNumber]              VARCHAR (50) NULL,
    [ComboType]                VARCHAR (10) NULL,
    [MasterVoucherNumber]      VARCHAR (50) NULL,
    [ChildVoucherNumber]       VARCHAR (50) NULL,
    [VoucherNumberGenerateWay] INT          NULL,
    [IsMasterProduct]          INT          NULL,
    [BeneficiaryInfoId]        INT          NULL,
    [IsFakeBeneficiaryInfoId]  INT          NULL);

