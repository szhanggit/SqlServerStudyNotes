CREATE TYPE [dbo].[CustomizationSectionType] AS TABLE (
    [VersionNumber]            INT           NOT NULL,
    [ClientQuotationProductId] INT           NOT NULL,
    [SCVTemplateId]            INT           NOT NULL,
    [SectionNumber]            TINYINT       NOT NULL,
    [Title]                    VARCHAR (40)  NOT NULL,
    [Description]              VARCHAR (100) NULL,
    [ActivationStart]          DATETIME      NOT NULL,
    [ActivationEnd]            DATETIME      NOT NULL,
    [CreatedBy]                NVARCHAR (50) NOT NULL,
    [VersionTime]              DATETIME      NOT NULL);

