CREATE TABLE [dbo].[TrustAccountReference] (
    [Id]        INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ReferType] INT NOT NULL,
    [ReferId]   INT NOT NULL,
    CONSTRAINT [PK_TrustAccountReference] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UK_TrustAccountReference] UNIQUE NONCLUSTERED ([ReferType] ASC, [ReferId] ASC)
);

