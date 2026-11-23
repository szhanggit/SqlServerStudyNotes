CREATE TABLE [product].[tb_p_product_redeem_date_blacklist] (
    [product_redeem_date_blacklist_id] INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    CONSTRAINT [pk_tb_p_product_redeem_date_blacklist] PRIMARY KEY CLUSTERED ([product_redeem_date_blacklist_id] ASC)
);

