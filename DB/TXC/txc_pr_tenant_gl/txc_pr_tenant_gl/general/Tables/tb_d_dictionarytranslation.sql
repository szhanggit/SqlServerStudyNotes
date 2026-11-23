CREATE TABLE [general].[tb_d_dictionarytranslation] (
    [dictionary_translation_id] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [dictionary_id]             INT            NOT NULL,
    [language]                  NVARCHAR (5)   NOT NULL,
    [display_content]           NVARCHAR (500) NOT NULL,
    [tx2id]                     INT            NULL,
    [timestamp]                 ROWVERSION     NOT NULL,
    CONSTRAINT [PK_DictionaryTranslation] PRIMARY KEY CLUSTERED ([dictionary_translation_id] ASC),
    CONSTRAINT [UK_DictionaryTranslation_DictionaryId_Language] UNIQUE NONCLUSTERED ([dictionary_id] ASC, [language] ASC)
);

