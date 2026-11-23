CREATE TABLE [dbo].[tb_osb_order_sku_batch] (
    [id]            INT        IDENTITY (1, 1) NOT NULL,
    [batch_id]      INT        NOT NULL,
    [order_id]      INT        NOT NULL,
    [order_line_id] INT        NOT NULL,
    [quantity]      INT        NOT NULL,
    [sku_id]        INT        NOT NULL,
    [row_version]   ROWVERSION NOT NULL,
    CONSTRAINT [PK_tb_osb_order_sku_batch] PRIMARY KEY CLUSTERED ([id] ASC)
);

