CREATE TABLE [dbo].[TXCUpdateContractSync] (
    [Id]                   INT             IDENTITY (1, 1) NOT NULL,
    [RunId]                VARCHAR (50)    NULL,
    [StartDate]            DATETIME        NULL,
    [EndDate]              DATETIME        NULL,
    [TXCTenantId]          INT             NULL,
    [TXCContractSkuCostId] INT             NULL,
    [SessionId]            VARCHAR (50)    NULL,
    [Cost]                 DECIMAL (18, 4) NULL,
    [TXCProductId]         INT             NULL,
    [TX2ProductId]         INT             NULL,
    [TXCMerchantId]        INT             NULL,
    [TX2MerchantId]        INT             NULL,
    [TX2ProductVersionId]  INT             NULL,
    [UpdatedBy]            VARCHAR (50)    NULL,
    [CostWithTax]          DECIMAL (18, 4) DEFAULT (NULL) NULL,
    CONSTRAINT [PK_TXCUpdateContractSync_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IDX_TXCUpdateContractSync_RunId]
    ON [dbo].[TXCUpdateContractSync]([RunId] ASC) WITH (FILLFACTOR = 90);

