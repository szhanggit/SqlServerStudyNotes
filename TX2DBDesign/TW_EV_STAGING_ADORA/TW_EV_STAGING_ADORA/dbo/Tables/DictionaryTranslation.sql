CREATE TABLE [dbo].[DictionaryTranslation] (
    [DictionaryId]   INT            NOT NULL,
    [Language]       NVARCHAR (5)   NOT NULL,
    [DisplayContent] NVARCHAR (500) NOT NULL,
    CONSTRAINT [FK_DictionaryTranslation_Dictionary_DictionaryId] FOREIGN KEY ([DictionaryId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [UK_DictionaryTranslation_DictionaryId_Language] UNIQUE NONCLUSTERED ([DictionaryId] ASC, [Language] ASC)
);

