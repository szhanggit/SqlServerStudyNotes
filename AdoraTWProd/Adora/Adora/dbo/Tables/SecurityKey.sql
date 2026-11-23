CREATE TABLE [dbo].[SecurityKey] (
    [Id]    INT          IDENTITY (1, 1) NOT NULL,
    [Value] VARCHAR (48) NOT NULL,
    CONSTRAINT [PK_SecurityKey] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);

