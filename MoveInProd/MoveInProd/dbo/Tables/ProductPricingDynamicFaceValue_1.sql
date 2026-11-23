CREATE TABLE [dbo].[ProductPricingDynamicFaceValue] (
    [Id]                  INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProductVersionId]    INT             NOT NULL,
    [DefaultSellingPrice] DECIMAL (10, 4) NOT NULL,
    [DefaultProductCost]  DECIMAL (10, 4) NOT NULL,
    CONSTRAINT [PK_ProductPricingDynamicFaceValue_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ProductPricingDynamicFaceValue_ProductVersion_Id] FOREIGN KEY ([ProductVersionId]) REFERENCES [dbo].[ProductVersion] ([Id]),
    CONSTRAINT [UQ_ProductVersionId] UNIQUE NONCLUSTERED ([ProductVersionId] ASC)
);

