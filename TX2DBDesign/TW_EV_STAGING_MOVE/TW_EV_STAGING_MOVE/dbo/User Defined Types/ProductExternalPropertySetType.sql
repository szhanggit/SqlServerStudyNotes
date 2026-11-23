CREATE TYPE [dbo].[ProductExternalPropertySetType] AS TABLE (
    [PropertyName]  NVARCHAR (100) NOT NULL,
    [PropertyValue] NVARCHAR (500) NOT NULL,
    [Description]   NVARCHAR (500) NOT NULL,
    PRIMARY KEY CLUSTERED ([PropertyName] ASC, [PropertyValue] ASC));

