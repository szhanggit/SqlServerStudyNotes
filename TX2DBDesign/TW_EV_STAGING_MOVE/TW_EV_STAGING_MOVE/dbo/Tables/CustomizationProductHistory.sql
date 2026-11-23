CREATE TABLE [dbo].[CustomizationProductHistory] (
    [Id]                            INT           IDENTITY (1, 1) NOT NULL,
    [ClientQuotationProductComboId] INT           NOT NULL,
    [VersionNumber]                 INT           NOT NULL,
    [CustomizationSectionId]        INT           NOT NULL,
    [SectionNumber]                 TINYINT       NOT NULL,
    [ActivationStart]               DATETIME      NOT NULL,
    [ActivationEnd]                 DATETIME      NOT NULL,
    [CreatedBy]                     NVARCHAR (50) NOT NULL,
    [VersionTime]                   DATETIME      NOT NULL,
    CONSTRAINT [PK_CustomizationProductHistory_Id] PRIMARY KEY CLUSTERED ([Id] DESC)
);


GO
CREATE NONCLUSTERED INDEX [Index_CustomizationProductHistory_ClientQuotationProductId]
    ON [dbo].[CustomizationProductHistory]([CustomizationSectionId] ASC, [VersionNumber] ASC);

