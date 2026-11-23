CREATE TABLE [dbo].[TXCCreateContractSync] (
    [Id]                   INT             IDENTITY (1, 1) NOT NULL,
    [RunId]                VARCHAR (50)    NULL,
    [StartDate]            DATETIME        NULL,
    [EndDate]              DATETIME        NULL,
    [TXCProductId]         INT             NULL,
    [TX2ProductId]         INT             NULL,
    [TXCTenantId]          INT             NULL,
    [TXCContractSkuCostId] INT             NULL,
    [TXCMerchantId]        INT             NULL,
    [TX2MerchantId]        INT             NULL,
    [Cost]                 DECIMAL (18, 4) NULL,
    [TX2ProductVersionId]  INT             NULL,
    [CreatedBy]            VARCHAR (50)    NULL,
    [CreatedOn]            DATETIME        NULL,
    [SessionId]            VARCHAR (50)    NULL,
    [CostWithTax]          DECIMAL (18, 4) DEFAULT (NULL) NULL,
    CONSTRAINT [PK_TXCCreateContractSync_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IDX_TXCCreateContractSync_RunId]
    ON [dbo].[TXCCreateContractSync]([RunId] ASC) WITH (FILLFACTOR = 90);

