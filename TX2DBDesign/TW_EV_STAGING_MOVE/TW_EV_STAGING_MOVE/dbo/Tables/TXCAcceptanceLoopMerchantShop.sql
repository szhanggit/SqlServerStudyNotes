CREATE TABLE [dbo].[TXCAcceptanceLoopMerchantShop] (
    [acceptance_loop_merchant_shop_id] INT            IDENTITY (1, 1) NOT NULL,
    [acceptance_loop_merchant_id]      INT            NOT NULL,
    [shop_id]                          INT            NOT NULL,
    [status]                           BIT            NOT NULL,
    [created_by]                       NVARCHAR (250) NOT NULL,
    [created_on]                       DATETIME       NOT NULL,
    [last_updated_by]                  NVARCHAR (250) NULL,
    [last_updated_on]                  DATETIME       NULL,
    CONSTRAINT [PK_tb_alms_acceptance_loop_merchant_shop] PRIMARY KEY CLUSTERED ([acceptance_loop_merchant_shop_id] ASC) WITH (FILLFACTOR = 90)
);

