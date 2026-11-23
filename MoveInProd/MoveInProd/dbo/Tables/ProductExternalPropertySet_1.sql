CREATE TABLE [dbo].[ProductExternalPropertySet] (
    [Id]                        INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProductExternalPropertyId] INT            NOT NULL,
    [PropertyName]              NVARCHAR (100) NOT NULL,
    [PropertyValue]             NVARCHAR (500) NOT NULL,
    [Description]               NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK_PRODUCTEXTERNALPROPERTYSET] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ProductExternalPropertySet_ProductExternalProperty_ProductExternalPropertyId] FOREIGN KEY ([ProductExternalPropertyId]) REFERENCES [dbo].[ProductExternalProperty] ([Id])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1--Mon
   2--Tue
   3--Wed
   4--Thu
   5--Fri
   6--Sat
   7--Sun', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductExternalPropertySet', @level2type = N'COLUMN', @level2name = N'PropertyName';

