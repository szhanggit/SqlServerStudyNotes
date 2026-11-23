CREATE TABLE [dbo].[SpecialSLMSTemplateVersion] (
    [Id]                    BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SLMSTemplateVersionId] INT          NOT NULL,
    [ReferType]             TINYINT      NOT NULL,
    [ReferId]               BIGINT       NOT NULL,
    [ProductCode]           VARCHAR (50) NULL,
    CONSTRAINT [PK_SpecialSLMSTemplateVersion] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_SpecialSLMSTemplateVersion_SLMSTemplateVersion_SLMSTemplateVersionId] FOREIGN KEY ([SLMSTemplateVersionId]) REFERENCES [dbo].[SLMSTemplateVersion] ([Id])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1--Product
   2--Order
   3--Wizard', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SpecialSLMSTemplateVersion', @level2type = N'COLUMN', @level2name = N'ReferType';

