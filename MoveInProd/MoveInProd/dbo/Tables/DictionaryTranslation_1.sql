CREATE TABLE [dbo].[DictionaryTranslation] (
    [Id]             INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [DictionaryId]   INT            NOT NULL,
    [Language]       NVARCHAR (5)   NOT NULL,
    [DisplayContent] NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK_DictionaryTranslation] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_DictionaryTranslation_Dictionary_DictionaryId] FOREIGN KEY ([DictionaryId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [UK_DictionaryTranslation_DictionaryId_Language] UNIQUE NONCLUSTERED ([DictionaryId] ASC, [Language] ASC)
);

