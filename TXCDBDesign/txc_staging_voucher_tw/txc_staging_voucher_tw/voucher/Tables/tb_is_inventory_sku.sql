CREATE TABLE [voucher].[tb_is_inventory_sku] (
    [sku_id]               INT        NOT NULL,
    [warning_water_level]  INT        NOT NULL,
    [replenish_quantity]   INT        NOT NULL,
    [api_order_buffer]     INT        NOT NULL,
    [procurement_quantity] INT        NOT NULL,
    [row_version]          ROWVERSION NOT NULL,
    CONSTRAINT [PK_inventory_sku_sku_id] PRIMARY KEY CLUSTERED ([sku_id] ASC)
);

