CREATE TABLE [dbo].[TimezoneOffset] (
    [Id]     INT         NOT NULL,
    [Offset] VARCHAR (6) NOT NULL,
    CONSTRAINT [PK_TimezoneOffset] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TimezoneOffset_Dictionary_Id] FOREIGN KEY ([Id]) REFERENCES [dbo].[Dictionary] ([Id])
);

