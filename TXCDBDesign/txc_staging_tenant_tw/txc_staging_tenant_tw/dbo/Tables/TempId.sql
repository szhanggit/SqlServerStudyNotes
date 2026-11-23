CREATE TABLE [dbo].[TempId] (
    [Id]        INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientId]  INT NULL,
    [AddressId] INT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

