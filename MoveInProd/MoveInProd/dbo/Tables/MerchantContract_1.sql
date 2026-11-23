CREATE TABLE [dbo].[MerchantContract] (
    [Id]               INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MerchantId]       INT           NOT NULL,
    [ProductVersionId] INT           NOT NULL,
    [ValidFrom]        DATETIME      NOT NULL,
    [ValidTo]          DATETIME      NOT NULL,
    [IsUseDefaultCost] BIT           DEFAULT ((0)) NOT NULL,
    [CreatedBy]        NVARCHAR (50) NOT NULL,
    [CreatedOn]        DATETIME      NOT NULL,
    CONSTRAINT [PK_MERCHANTCONTRACT] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_MerchantContract_Merchant_MerchantId] FOREIGN KEY ([MerchantId]) REFERENCES [dbo].[Merchant] ([Id]),
    CONSTRAINT [FK_MerchnatContract_ProductVersion_ProductVersionId] FOREIGN KEY ([ProductVersionId]) REFERENCES [dbo].[ProductVersion] ([Id])
);

