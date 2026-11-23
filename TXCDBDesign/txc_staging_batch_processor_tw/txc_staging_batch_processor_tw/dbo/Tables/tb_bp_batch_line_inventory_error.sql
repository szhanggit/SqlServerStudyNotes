CREATE TABLE [dbo].[tb_bp_batch_line_inventory_error] (
    [batch_line_inventory_error_id] BIGINT   IDENTITY (1, 1) NOT NULL,
    [batch_inventory_detail_id]     BIGINT   NOT NULL,
    [batch_line_error_master_id]    INT      NOT NULL,
    [updated_on]                    DATETIME NOT NULL,
    CONSTRAINT [PK_tb_bp_batch_line_inventory_error_id] PRIMARY KEY CLUSTERED ([batch_line_inventory_error_id] ASC),
    CONSTRAINT [FK_tb_bp_batch_line_error_master_tb_bp_batch_line_inventory_error] FOREIGN KEY ([batch_line_error_master_id]) REFERENCES [dbo].[tb_bp_batch_line_error_master] ([batch_line_error_master_id]),
    CONSTRAINT [FK_tb_bp_batch_line_inventory_detail_tb_bp_batch_line_voucher_operations_error] FOREIGN KEY ([batch_inventory_detail_id]) REFERENCES [dbo].[tb_bp_batch_line_inventory_detail] ([batch_line_inventory_detail_id])
);

