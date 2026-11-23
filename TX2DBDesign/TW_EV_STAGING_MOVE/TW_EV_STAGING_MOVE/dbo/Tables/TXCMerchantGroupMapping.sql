CREATE TABLE [dbo].[TXCMerchantGroupMapping] (
    [merchant_group_merchant_map_id] INT IDENTITY (1, 1) NOT NULL,
    [merchant_group_id]              INT NOT NULL,
    [merchant_id]                    INT NOT NULL,
    [status]                         BIT NOT NULL,
    CONSTRAINT [PK_TXCMerchantGroupMapping] PRIMARY KEY CLUSTERED ([merchant_group_merchant_map_id] ASC) WITH (FILLFACTOR = 90)
);

