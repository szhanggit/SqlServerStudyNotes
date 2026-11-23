CREATE TABLE [dbo].[RestrictionDayOfWeek] (
    [Id]            INT     IDENTITY (1, 1) NOT NULL,
    [RestrictionId] INT     NULL,
    [DayOfWeek]     TINYINT NOT NULL,
    CONSTRAINT [PK_RestrictionDayOfWeek_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC),
    CONSTRAINT [FK_RVDayOfWeek_RVRestrictionVelocity_RVId] FOREIGN KEY ([RestrictionId]) REFERENCES [dbo].[Restriction] ([Id])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '0--Sun
   1--Mon
   2--Tue
   3--Wed
   4--Thu
   5--Fri
   6--Sat', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RestrictionDayOfWeek', @level2type = N'COLUMN', @level2name = N'DayOfWeek';

