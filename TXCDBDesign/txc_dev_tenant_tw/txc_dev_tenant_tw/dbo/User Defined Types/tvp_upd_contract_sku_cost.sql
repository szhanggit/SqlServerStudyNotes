CREATE TYPE [dbo].[tvp_upd_contract_sku_cost] AS TABLE (
    [SkuCostId]      INT             NOT NULL,
    [ContractId]     INT             NOT NULL,
    [SkuId]          INT             NOT NULL,
    [CostWithTax]    DECIMAL (18, 4) NOT NULL,
    [CostWithoutTax] DECIMAL (18, 4) NOT NULL,
    [ValidStartDate] DATETIME        NULL,
    [ValidEndDate]   DATETIME        NULL,
    [StatusId]       INT             NOT NULL);

