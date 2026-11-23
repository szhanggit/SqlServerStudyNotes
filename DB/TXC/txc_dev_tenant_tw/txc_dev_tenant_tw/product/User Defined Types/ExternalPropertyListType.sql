CREATE TYPE [product].[ExternalPropertyListType] AS TABLE (
    [property_name]  NVARCHAR (100) NOT NULL,
    [property_value] NVARCHAR (500) NOT NULL,
    [description]    NVARCHAR (500) NOT NULL,
    PRIMARY KEY CLUSTERED ([property_name] ASC));

