CREATE TABLE [dbo].[TXCMerchantGroup] (
    [merchant_group_id] INT      NOT NULL,
    [created_on]        DATETIME NOT NULL,
    CONSTRAINT [PK_tb_mg_merchant_group] PRIMARY KEY CLUSTERED ([merchant_group_id] ASC) WITH (FILLFACTOR = 90)
);

