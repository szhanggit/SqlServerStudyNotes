CREATE TABLE [dbo].[LEIdTemp] (
    [AccountLEId] BIGINT NOT NULL,
    [Id]          INT    IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_LEIdTemp] PRIMARY KEY CLUSTERED ([Id] ASC)
);

