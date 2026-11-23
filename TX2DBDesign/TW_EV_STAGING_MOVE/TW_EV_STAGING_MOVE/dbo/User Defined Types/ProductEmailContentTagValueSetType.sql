CREATE TYPE [dbo].[ProductEmailContentTagValueSetType] AS TABLE (
    [ContentTagId] INT            NOT NULL,
    [Value]        NVARCHAR (MAX) NULL,
    [TextValue]    NVARCHAR (MAX) NULL);

