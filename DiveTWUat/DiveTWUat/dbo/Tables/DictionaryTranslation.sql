CREATE TABLE [dbo].[DictionaryTranslation] (
    [Id]             INT            IDENTITY (1, 1) NOT NULL,
    [DictionaryId]   INT            NOT NULL,
    [Language]       NVARCHAR (5)   NOT NULL,
    [DisplayContent] NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK_DictionaryTranslation] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_DICTIONA_REFERENCE_DICTIONA] FOREIGN KEY ([DictionaryId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [UK_DictionaryTranslation_DictionaryId_Language] UNIQUE NONCLUSTERED ([DictionaryId] ASC, [Language] ASC)
);

