CREATE TABLE [dbo].[CustomizationProduct] (
    [Id]                            INT           IDENTITY (1, 1) NOT NULL,
    [ClientQuotationProductComboId] INT           NOT NULL,
    [VersionNumber]                 INT           NOT NULL,
    [CustomizationSectionId]        INT           NOT NULL,
    [SectionNumber]                 TINYINT       NOT NULL,
    [ActivationStart]               DATETIME      NOT NULL,
    [ActivationEnd]                 DATETIME      NOT NULL,
    [CreatedBy]                     NVARCHAR (50) NOT NULL,
    [VersionTime]                   DATETIME      NOT NULL,
    CONSTRAINT [PK_CustomizationProduct_Id] PRIMARY KEY CLUSTERED ([Id] DESC)
);


GO
CREATE NONCLUSTERED INDEX [Index_CustomizationProduct_CustomizationSectionId]
    ON [dbo].[CustomizationProduct]([CustomizationSectionId] ASC);

