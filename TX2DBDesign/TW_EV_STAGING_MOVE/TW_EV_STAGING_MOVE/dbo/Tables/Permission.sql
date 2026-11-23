CREATE TABLE [dbo].[Permission] (
    [Id]          INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]        VARCHAR (50) NOT NULL,
    [DisplayName] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Permission] PRIMARY KEY CLUSTERED ([Id] ASC)
);

