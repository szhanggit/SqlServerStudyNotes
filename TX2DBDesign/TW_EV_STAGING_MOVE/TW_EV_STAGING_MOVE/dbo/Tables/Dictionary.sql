CREATE TABLE [dbo].[Dictionary] (
    [Id]          INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Category]    NVARCHAR (50)  NOT NULL,
    [Name]        NVARCHAR (50)  NOT NULL,
    [DisplayName] NVARCHAR (500) NOT NULL,
    [ParentId]    INT            NULL,
    CONSTRAINT [PK_Dictionary] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Dictionary_Dictionary_ParentId] FOREIGN KEY ([ParentId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [UK_Dictionary_Category_Name] UNIQUE NONCLUSTERED ([Category] ASC, [Name] ASC)
);

