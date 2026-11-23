CREATE TYPE [product].[TimeRestrictionListType] AS TABLE (
    [day_of_week] TINYINT  NOT NULL,
    [start_time]  TIME (7) NOT NULL,
    [end_time]    TIME (7) NOT NULL,
    PRIMARY KEY CLUSTERED ([day_of_week] ASC, [start_time] ASC));

