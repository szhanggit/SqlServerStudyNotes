CREATE TABLE [dbo].[OrderCancelRequest] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [OrderNumber] NVARCHAR (50) NOT NULL,
    [CreateTime]  DATETIME      NOT NULL,
    CONSTRAINT [PK_OrderCancelRequest_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

