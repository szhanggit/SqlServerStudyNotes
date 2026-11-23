CREATE TABLE [dbo].[OrderDetailActionHistory] (
    [Id]            BIGINT         IDENTITY (1, 1) NOT NULL,
    [OrderId]       INT            NOT NULL,
    [ActionType]    NVARCHAR (50)  NOT NULL,
    [ActionResult]  NVARCHAR (20)  NOT NULL,
    [Operator]      NVARCHAR (50)  NOT NULL,
    [ActionTime]    DATETIME       NOT NULL,
    [EmailReceiver] NVARCHAR (200) NULL,
    CONSTRAINT [PK_OrderDetailACTIONHISTORY] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_OrderDetailActionHistory_OrderDetail_OrderId] FOREIGN KEY ([OrderId]) REFERENCES [dbo].[Order] ([Id])
);

