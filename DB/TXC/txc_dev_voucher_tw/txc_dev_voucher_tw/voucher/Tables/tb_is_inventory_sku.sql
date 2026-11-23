CREATE TABLE [voucher].[tb_is_inventory_sku] (
    [sku_id]               INT NOT NULL,
    [warning_water_level]  INT NOT NULL,
    [replenish_quantity]   INT NOT NULL,
    [api_order_buffer]     INT NOT NULL,
    [procurement_quantity] INT NOT NULL,
    PRIMARY KEY CLUSTERED ([sku_id] ASC)
);

