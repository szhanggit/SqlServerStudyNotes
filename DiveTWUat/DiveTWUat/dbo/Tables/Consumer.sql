CREATE TABLE [dbo].[Consumer] (
    [Id]             INT            IDENTITY (1, 1) NOT NULL,
    [ConsumerCode]   NVARCHAR (8)   NOT NULL,
    [CountryId]      INT            NOT NULL,
    [ConsumerName]   NVARCHAR (50)  NOT NULL,
    [TimezoneOffset] VARCHAR (6)    NOT NULL,
    [IsOpen]         BIT            NOT NULL,
    [Description]    NVARCHAR (500) NULL,
    CONSTRAINT [PK_Consumer] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Consumer_Dictionary_CountryId] FOREIGN KEY ([CountryId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [UK_Consumer_ConsumerCode] UNIQUE NONCLUSTERED ([ConsumerCode] ASC)
);

