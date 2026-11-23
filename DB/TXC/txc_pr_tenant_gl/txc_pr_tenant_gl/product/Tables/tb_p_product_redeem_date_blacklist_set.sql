CREATE TABLE [product].[tb_p_product_redeem_date_blacklist_set] (
    [product_redeem_date_blacklist_set_id] INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [product_redeem_date_blacklist_id]     INT      NOT NULL,
    [black_date]                           DATETIME NOT NULL,
    CONSTRAINT [pk_tb_p_product_redeem_date_blacklist_set] PRIMARY KEY CLUSTERED ([product_redeem_date_blacklist_set_id] ASC),
    CONSTRAINT [FK_blacklist_sets] FOREIGN KEY ([product_redeem_date_blacklist_id]) REFERENCES [product].[tb_p_product_redeem_date_blacklist] ([product_redeem_date_blacklist_id])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_product_redeem_date_id_black_date]
    ON [product].[tb_p_product_redeem_date_blacklist_set]([product_redeem_date_blacklist_id] ASC, [black_date] ASC);

