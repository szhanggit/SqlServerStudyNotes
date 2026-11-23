CREATE TABLE [dbo].[OrderSyncStatusOperationHistory] (
    [Id]           BIGINT        IDENTITY (1, 1) NOT NULL,
    [OrderId]      INT           NOT NULL,
    [ActionType]   NVARCHAR (50) NOT NULL,
    [ActionResult] NVARCHAR (20) NOT NULL,
    [ActionTime]   DATETIME      NOT NULL,
    [Operator]     NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_OrderSyncStatusOperationHistory_Id] PRIMARY KEY CLUSTERED ([Id] DESC)
);


GO
CREATE NONCLUSTERED INDEX [Index_Self_OrderId]
    ON [dbo].[OrderSyncStatusOperationHistory]([OrderId] ASC);

