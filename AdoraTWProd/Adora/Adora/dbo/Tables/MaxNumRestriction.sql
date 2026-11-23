CREATE TABLE [dbo].[MaxNumRestriction] (
    [Id]        INT IDENTITY (1, 1) NOT NULL,
    [MaxNumber] INT NOT NULL,
    [CountDays] INT NOT NULL,
    CONSTRAINT [PK_MaxNumRestriction] PRIMARY KEY CLUSTERED ([Id] ASC)
);

