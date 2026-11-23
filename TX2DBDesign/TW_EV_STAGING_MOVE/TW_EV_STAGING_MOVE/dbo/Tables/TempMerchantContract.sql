CREATE TABLE [dbo].[TempMerchantContract] (
    [Id]                   INT             IDENTITY (1, 1) NOT NULL,
    [MerchantContractId]   INT             NULL,
    [ProductVersionId]     INT             NULL,
    [TXCContractSkuCostId] INT             NULL,
    [Cost]                 DECIMAL (18, 2) NULL,
    [MerchantId]           INT             NULL,
    [StartDate]            DATETIME        NULL,
    [EndDate]              DATETIME        NULL,
    CONSTRAINT [PK_TempMerchantContract_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

