CREATE TABLE [backup].[tb_p_product_redeem_time_restriction_set] (
    [product_redeem_time_restriction_set_id] INT      IDENTITY (1, 1) NOT NULL,
    [day_of_week]                            TINYINT  NOT NULL,
    [start_time]                             TIME (7) NOT NULL,
    [end_time]                               TIME (7) NOT NULL,
    [product_redeem_time_restriction_id]     INT      NOT NULL
);

