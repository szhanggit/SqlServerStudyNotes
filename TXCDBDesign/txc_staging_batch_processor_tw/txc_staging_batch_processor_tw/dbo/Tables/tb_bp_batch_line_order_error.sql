CREATE TABLE [dbo].[tb_bp_batch_line_order_error] (
    [batch_line_order_error_id]  BIGINT   IDENTITY (1, 1) NOT NULL,
    [batch_line_order_id]        BIGINT   NOT NULL,
    [batch_line_error_master_id] INT      NOT NULL,
    [updated_on]                 DATETIME NOT NULL,
    CONSTRAINT [PK_tb_bp_batch_line_order_error_id] PRIMARY KEY CLUSTERED ([batch_line_order_error_id] ASC),
    CONSTRAINT [FK_tb_bp_batch_line_error_master_tb_bp_batch_line_order_error] FOREIGN KEY ([batch_line_error_master_id]) REFERENCES [dbo].[tb_bp_batch_line_error_master] ([batch_line_error_master_id]),
    CONSTRAINT [FK_tb_bp_batch_line_order_detail_tb_bp_batch_line_order_error] FOREIGN KEY ([batch_line_order_id]) REFERENCES [dbo].[tb_bp_batch_line_order_detail] ([batch_order_detail_id])
);

