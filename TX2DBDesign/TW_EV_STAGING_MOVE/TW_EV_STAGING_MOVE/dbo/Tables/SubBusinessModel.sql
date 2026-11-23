CREATE TABLE [dbo].[SubBusinessModel] (
    [Id]              INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BusinessModelId] INT NOT NULL,
    [DisplayNameId]   INT NOT NULL,
    CONSTRAINT [PK_SUBBUSINESSMODEL] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_SubBusinessModel_BusinessModel_BusinessModelId] FOREIGN KEY ([BusinessModelId]) REFERENCES [dbo].[BusinessModel] ([Id])
);

