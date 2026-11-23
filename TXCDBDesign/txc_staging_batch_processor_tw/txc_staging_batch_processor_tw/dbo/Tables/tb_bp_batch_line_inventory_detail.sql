CREATE TABLE [dbo].[tb_bp_batch_line_inventory_detail] (
    [batch_line_inventory_detail_id] BIGINT         IDENTITY (1, 1) NOT NULL,
    [batch_line_id]                  BIGINT         NOT NULL,
    [voucher_number]                 NVARCHAR (50)  NOT NULL,
    [sku_code]                       NVARCHAR (50)  NOT NULL,
    [voucher_start_date]             DATETIME       NOT NULL,
    [voucher_end_date]               DATETIME       NOT NULL,
    [voucher_expiry_date]            DATETIME       NOT NULL,
    [trust_start_date]               DATETIME       NULL,
    [trust_end_date]                 DATETIME       NULL,
    [barcode1]                       NVARCHAR (50)  NULL,
    [barcode2]                       NVARCHAR (50)  NULL,
    [barcode3]                       NVARCHAR (50)  NULL,
    [barcode4]                       NVARCHAR (50)  NULL,
    [operator]                       NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_tb_bp_batch_line_inventory_detail_id] PRIMARY KEY CLUSTERED ([batch_line_inventory_detail_id] ASC),
    CONSTRAINT [FK_tb_bp_batch_line_tb_bp_batch_line_inventory_detail] FOREIGN KEY ([batch_line_id]) REFERENCES [dbo].[tb_bp_batch_line] ([batch_line_id]) ON DELETE CASCADE
);

