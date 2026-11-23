CREATE TABLE [dbo].[RestrictionDateBlacklist] (
    [Id]            INT  IDENTITY (1, 1) NOT NULL,
    [RestrictionId] INT  NULL,
    [BlockedDate]   DATE NOT NULL,
    CONSTRAINT [PK_RestrictionDateBlacklist_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC),
    CONSTRAINT [FK_RVDateBlacklist_RVRestrictionVelocity_RVId] FOREIGN KEY ([RestrictionId]) REFERENCES [dbo].[Restriction] ([Id])
);

