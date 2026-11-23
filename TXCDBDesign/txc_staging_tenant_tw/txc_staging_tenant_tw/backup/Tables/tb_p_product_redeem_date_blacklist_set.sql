CREATE TABLE [backup].[tb_p_product_redeem_date_blacklist_set] (
    [product_redeem_date_blacklist_set_id] INT      IDENTITY (1, 1) NOT NULL,
    [product_redeem_date_blacklist_id]     INT      NOT NULL,
    [black_date]                           DATETIME NOT NULL
);

