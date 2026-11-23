CREATE TABLE [dbo].[OrderStatusHistory] (
    [Id]            INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OrderId]       INT            NOT NULL,
    [Operation]     INT            NOT NULL,
    [Comment]       NVARCHAR (500) NULL,
    [Operator]      NVARCHAR (50)  NOT NULL,
    [OperationTime] DATETIME       NOT NULL,
    CONSTRAINT [PK_ORDERSTATUSHISTORY] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_OrderStatusHistory_Order_OrderId] FOREIGN KEY ([OrderId]) REFERENCES [dbo].[Order] ([Id])
);

