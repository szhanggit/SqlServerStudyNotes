CREATE TABLE [dbo].[RestrictionTimeOfDay] (
    [Id]          INT      IDENTITY (1, 1) NOT NULL,
    [DayOfWeekId] INT      NOT NULL,
    [TimeFrom]    TIME (7) NOT NULL,
    [TimeTo]      TIME (7) NOT NULL,
    CONSTRAINT [PK_RestrictionTimeOfDay_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC),
    CONSTRAINT [FK_RestrictionTimeOfDay_RestrictionDayOfWeek_DayOfWeekId] FOREIGN KEY ([DayOfWeekId]) REFERENCES [dbo].[RestrictionDayOfWeek] ([Id])
);

