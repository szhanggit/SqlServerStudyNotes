CREATE TYPE [dbo].[ProductRedeemTimeRestrictionSetType] AS TABLE (
    [DayOfTheWeek] TINYINT  NOT NULL,
    [StartTime]    TIME (7) NOT NULL,
    [EndTime]      TIME (7) NOT NULL,
    PRIMARY KEY CLUSTERED ([DayOfTheWeek] ASC, [StartTime] ASC));

