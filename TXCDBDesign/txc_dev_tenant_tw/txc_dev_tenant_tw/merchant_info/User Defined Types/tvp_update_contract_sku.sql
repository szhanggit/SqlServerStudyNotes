CREATE TYPE [merchant_info].[tvp_update_contract_sku] AS TABLE (
    [SkuId]               INT             NOT NULL,
    [ContractId]          INT             NOT NULL,
    [SkuName]             NVARCHAR (128)  NOT NULL,
    [SkuNumber]           NVARCHAR (128)  NOT NULL,
    [TypeId]              INT             NOT NULL,
    [FaceValueWithTax]    DECIMAL (18, 2) NULL,
    [VoucherNumberRuleId] INT             NOT NULL,
    [FaceValueWithOutTax] DECIMAL (18, 2) NULL,
    [Multiplier]          INT             NULL,
    [SkuCostId]           INT             NOT NULL,
    [CostWithTax]         DECIMAL (18, 4) NOT NULL,
    [CostWithoutTax]      DECIMAL (18, 4) NOT NULL,
    [ValidStartDate]      DATETIME        NOT NULL,
    [ValidEndDate]        DATETIME        NOT NULL,
    [StatusId]            INT             NOT NULL);

