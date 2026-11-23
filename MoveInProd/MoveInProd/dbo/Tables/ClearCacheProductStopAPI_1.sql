CREATE TABLE [dbo].[ClearCacheProductStopAPI] (
    [Id]        INT      IDENTITY (1, 1) NOT NULL,
    [ProductId] INT      NOT NULL,
    [Status]    INT      NOT NULL,
    [ValidEnd]  DATETIME NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Index_ClearCacheProductStopAPI_ProductId]
    ON [dbo].[ClearCacheProductStopAPI]([ProductId] ASC);

