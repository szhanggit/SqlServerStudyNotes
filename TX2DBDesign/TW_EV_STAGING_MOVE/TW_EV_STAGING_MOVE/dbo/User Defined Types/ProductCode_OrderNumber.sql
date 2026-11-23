CREATE TYPE [dbo].[ProductCode_OrderNumber] AS TABLE (
    [Id]          INT          IDENTITY (1, 1) NOT NULL,
    [ProductCode] VARCHAR (50) NULL,
    [OrderNumber] VARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC));

