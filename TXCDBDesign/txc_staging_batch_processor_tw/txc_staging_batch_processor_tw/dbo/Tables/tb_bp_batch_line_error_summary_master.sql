CREATE TABLE [dbo].[tb_bp_batch_line_error_summary_master] (
    [batch_line_error_summary_id] INT            IDENTITY (1, 1) NOT NULL,
    [description]                 NVARCHAR (300) NULL,
    PRIMARY KEY CLUSTERED ([batch_line_error_summary_id] ASC)
);

