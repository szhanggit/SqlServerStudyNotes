CREATE TABLE [dbo].[tb_bp_batch_line] (
    [batch_line_id]         BIGINT         IDENTITY (1, 1) NOT NULL,
    [batch_id]              BIGINT         NOT NULL,
    [row_number]            INT            NOT NULL,
    [row_item_json]         NVARCHAR (MAX) NOT NULL,
    [batch_state_master_id] INT            NOT NULL,
    [processed_start_date]  DATETIME       NOT NULL,
    [processed_end_date]    DATETIME       NULL,
    CONSTRAINT [PK_tb_bp_batch_line_batch_line_id] PRIMARY KEY CLUSTERED ([batch_line_id] ASC),
    CONSTRAINT [FK_tb_bp_batch_master_tb_bp_batch_line] FOREIGN KEY ([batch_id]) REFERENCES [dbo].[tb_bp_batch_master] ([batch_id]) ON DELETE CASCADE,
    CONSTRAINT [FK_tb_bp_batch_state_master_tb_bp_batch_line] FOREIGN KEY ([batch_state_master_id]) REFERENCES [dbo].[tb_bp_batch_state_master] ([batch_state_master_id])
);

