CREATE TABLE [dbo].[TXCMerchantMapping] (
    [Id]            BIGINT IDENTITY (1, 1) NOT NULL,
    [TX2MerchantId] INT    NOT NULL,
    [TXCMerchantId] INT    NULL,
    [TenantId]      INT    NOT NULL,
    CONSTRAINT [PK_TXCMerchantMapping_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

