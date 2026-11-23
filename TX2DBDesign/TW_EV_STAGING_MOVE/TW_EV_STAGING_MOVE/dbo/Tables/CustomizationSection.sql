CREATE TABLE [dbo].[CustomizationSection] (
    [Id]                       INT           IDENTITY (1, 1) NOT NULL,
    [VersionNumber]            INT           NOT NULL,
    [ClientQuotationProductId] INT           NOT NULL,
    [SCVTemplateId]            INT           NOT NULL,
    [SectionNumber]            TINYINT       NOT NULL,
    [Title]                    VARCHAR (40)  NOT NULL,
    [Description]              VARCHAR (100) NULL,
    [ActivationStart]          DATETIME      NOT NULL,
    [ActivationEnd]            DATETIME      NOT NULL,
    [CreatedBy]                NVARCHAR (50) NOT NULL,
    [VersionTime]              DATETIME      NOT NULL,
    CONSTRAINT [PK_CustomizationSection_Id] PRIMARY KEY CLUSTERED ([Id] DESC),
    CONSTRAINT [FK_CustomizationSection_ClientQuotationProduct_ClientQuotationProductId] FOREIGN KEY ([ClientQuotationProductId]) REFERENCES [dbo].[ClientQuotationProduct] ([Id]),
    CONSTRAINT [FK_CustomizationSection_SCVTemplate_TemplateId] FOREIGN KEY ([SCVTemplateId]) REFERENCES [dbo].[SCVTemplate] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [Index_CustomizationSection_ClientQuotationProductId]
    ON [dbo].[CustomizationSection]([ClientQuotationProductId] ASC);

