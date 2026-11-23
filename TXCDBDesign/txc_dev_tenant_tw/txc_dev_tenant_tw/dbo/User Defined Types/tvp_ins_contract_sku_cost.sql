CREATE TYPE [dbo].[tvp_ins_contract_sku_cost] AS TABLE (
    [SkuId]          INT             NOT NULL,
    [CostWithTax]    DECIMAL (18, 4) NOT NULL,
    [CostWithoutTax] DECIMAL (18, 4) NOT NULL,
    [validstartDate] DATETIME        NULL,
    [validEndDate]   DATETIME        NULL);

