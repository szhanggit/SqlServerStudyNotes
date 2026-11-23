CREATE TABLE [dbo].[OrderChannelInfo] (
    [OrderId]   INT NOT NULL,
    [ChannelId] INT NOT NULL,
    CONSTRAINT [PK_OrderChannelInfo_OrderId] PRIMARY KEY CLUSTERED ([OrderId] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [Index_OrderChannelInfo_ChannelId]
    ON [dbo].[OrderChannelInfo]([ChannelId] ASC) WITH (FILLFACTOR = 90);

