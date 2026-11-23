CREATE TABLE [dbo].[AutoCreateOrderExecleInfo] (
    [OrderId] INT NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [idx_AutoCreateOrderExecleInfo_OrderId]
    ON [dbo].[AutoCreateOrderExecleInfo]([OrderId] ASC);

