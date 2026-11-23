CREATE TABLE [dbo].[OrderActionHistory] (
    [Id]        INT            IDENTITY (1, 1) NOT NULL,
    [OrderId]   INT            NOT NULL,
    [Operation] INT            NOT NULL,
    [Operator]  NVARCHAR (50)  NOT NULL,
    [CreatedOn] DATETIME       NOT NULL,
    [Comment]   NVARCHAR (500) NULL,
    [Result]    NVARCHAR (50)  NULL,
    [RequestId] NVARCHAR (50)  NULL,
    CONSTRAINT [PK_ORDERACTIONHISTORY] PRIMARY KEY CLUSTERED ([Id] ASC)
);

