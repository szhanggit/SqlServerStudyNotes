CREATE TABLE [product].[tb_p_product_redeem_time_restriction_set] (
    [product_redeem_time_restriction_set_id] INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [day_of_week]                            TINYINT  NOT NULL,
    [start_time]                             TIME (7) NOT NULL,
    [end_time]                               TIME (7) NOT NULL,
    [product_redeem_time_restriction_id]     INT      NOT NULL,
    CONSTRAINT [pk_tb_p_product_redeem_time_restriction_set] PRIMARY KEY CLUSTERED ([product_redeem_time_restriction_set_id] ASC),
    CONSTRAINT [FK_time_restriction_sets] FOREIGN KEY ([product_redeem_time_restriction_id]) REFERENCES [product].[tb_p_product_redeem_time_restriction] ([product_redeem_time_restriction_id])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_product_redeem_time_id_time]
    ON [product].[tb_p_product_redeem_time_restriction_set]([product_redeem_time_restriction_id] ASC, [day_of_week] ASC, [start_time] ASC);

