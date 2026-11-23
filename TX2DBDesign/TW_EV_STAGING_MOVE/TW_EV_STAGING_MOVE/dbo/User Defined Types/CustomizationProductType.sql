CREATE TYPE [dbo].[CustomizationProductType] AS TABLE (
    [ClientQuotationProductComboId] INT           NOT NULL,
    [VersionNumber]                 INT           NOT NULL,
    [CustomizationSectionId]        INT           NOT NULL,
    [SectionNumber]                 TINYINT       NOT NULL,
    [ActivationStart]               DATETIME      NOT NULL,
    [ActivationEnd]                 DATETIME      NOT NULL,
    [CreatedBy]                     NVARCHAR (50) NOT NULL,
    [VersionTime]                   DATETIME      NOT NULL);

