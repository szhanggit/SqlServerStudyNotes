CREATE TABLE [dbo].[tb_bp_batch_line_error] (
    [batch_line_error_id]        BIGINT   IDENTITY (1, 1) NOT NULL,
    [batch_line_id]              BIGINT   NOT NULL,
    [batch_line_error_master_id] INT      NOT NULL,
    [updated_on]                 DATETIME NOT NULL,
    CONSTRAINT [PK_tb_bp_batch_line_error_id] PRIMARY KEY CLUSTERED ([batch_line_error_id] ASC),
    CONSTRAINT [FK_tb_bp_batch_line_error_master_tb_bp_batch_line_error] FOREIGN KEY ([batch_line_error_master_id]) REFERENCES [dbo].[tb_bp_batch_line_error_master] ([batch_line_error_master_id]),
    CONSTRAINT [FK_tb_bp_batch_line_tb_bp_batch_line_error] FOREIGN KEY ([batch_line_id]) REFERENCES [dbo].[tb_bp_batch_line] ([batch_line_id])
);

