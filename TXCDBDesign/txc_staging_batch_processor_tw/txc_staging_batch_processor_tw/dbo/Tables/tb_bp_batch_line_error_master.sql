CREATE TABLE [dbo].[tb_bp_batch_line_error_master] (
    [batch_line_error_master_id]  INT            IDENTITY (1, 1) NOT NULL,
    [description]                 NVARCHAR (300) NOT NULL,
    [batch_line_error_summary_id] INT            NOT NULL,
    CONSTRAINT [PK_tb_bp_batch_line_error_master_batch_line_error_master_id] PRIMARY KEY CLUSTERED ([batch_line_error_master_id] ASC),
    CONSTRAINT [FK_tb_bp_batch_line_error_summary_master_tb_bp_batch_line_error_master] FOREIGN KEY ([batch_line_error_summary_id]) REFERENCES [dbo].[tb_bp_batch_line_error_summary_master] ([batch_line_error_summary_id])
);

