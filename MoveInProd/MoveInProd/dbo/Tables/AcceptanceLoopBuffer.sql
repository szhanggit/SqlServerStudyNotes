CREATE TABLE [dbo].[AcceptanceLoopBuffer] (
    [AcceptanceLoopUpdateId] VARCHAR (50) NOT NULL,
    [MerchantId]             INT          NOT NULL,
    [ShopId]                 INT          NOT NULL,
    [ProductId]              INT          NOT NULL,
    [CreatedOn]              DATETIME     NOT NULL
);


GO
CREATE CLUSTERED INDEX [IX_AcceptanceLoopBuffer]
    ON [dbo].[AcceptanceLoopBuffer]([AcceptanceLoopUpdateId] ASC);

