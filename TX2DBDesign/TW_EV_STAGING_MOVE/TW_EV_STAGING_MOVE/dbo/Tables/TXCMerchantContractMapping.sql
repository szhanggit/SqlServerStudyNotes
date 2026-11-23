CREATE TABLE [dbo].[TXCMerchantContractMapping] (
    [MerchantContractId]   INT NOT NULL,
    [TenantId]             INT NOT NULL,
    [TXCContractSkuCostId] INT NULL,
    CONSTRAINT [PK_TXCMerchantContractMapping] PRIMARY KEY CLUSTERED ([MerchantContractId] ASC, [TenantId] ASC) WITH (FILLFACTOR = 90)
);

