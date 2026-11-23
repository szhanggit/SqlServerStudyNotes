CREATE TABLE [dbo].[TXCDictionaryTranslationMapping] (
    [DictionaryTranslationId] INT NOT NULL,
    [TXCTenantId]             INT NOT NULL,
    [ExternalId]              INT NULL,
    CONSTRAINT [PK_TXCDictionaryTranslationMapping] PRIMARY KEY CLUSTERED ([DictionaryTranslationId] ASC)
);

