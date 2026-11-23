CREATE TABLE [dbo].[ExtensionScheme] (
    [Id]            INT     IDENTITY (1, 1) NOT NULL,
    [Type]          TINYINT NOT NULL,
    [ValidPeriod]   INT     NULL,
    [DisplayNameId] INT     NOT NULL,
    CONSTRAINT [PK_ExtensionScheme_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ExtensionScheme_Dictionary_DisplayNameId] FOREIGN KEY ([DisplayNameId]) REFERENCES [dbo].[Dictionary] ([Id])
);

