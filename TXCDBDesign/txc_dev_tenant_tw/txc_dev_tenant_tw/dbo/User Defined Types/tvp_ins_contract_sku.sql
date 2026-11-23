CREATE TYPE [dbo].[tvp_ins_contract_sku] AS TABLE (
    [SkuName]             NVARCHAR (128)  NOT NULL,
    [SkuNumber]           NVARCHAR (128)  NOT NULL,
    [FaceValueWithTax]    DECIMAL (18, 2) NULL,
    [FaceValueWithOutTax] DECIMAL (20, 4) NULL,
    [SkuTypeId]           INT             NOT NULL,
    [VoucherNumberRuleId] INT             NOT NULL,
    [Multiplier]          INT             NULL);

