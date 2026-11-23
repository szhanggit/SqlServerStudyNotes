CREATE TABLE [dbo].[ProductRedeemDateBlacklistSet] (
    [Id]                           INT  IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProductRedeemDateBlacklistId] INT  NOT NULL,
    [BlackDate]                    DATE NOT NULL,
    CONSTRAINT [PK_PRODUCTREDEEMDATEBLACKLISTS] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ProductRedeemDateBlacklistSet_ProductRedeemDateBlacklist_ProductRedeemDateBlacklistId] FOREIGN KEY ([ProductRedeemDateBlacklistId]) REFERENCES [dbo].[ProductRedeemDateBlacklist] ([Id])
);

