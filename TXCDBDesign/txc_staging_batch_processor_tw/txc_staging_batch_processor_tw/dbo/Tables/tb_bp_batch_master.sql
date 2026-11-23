CREATE TABLE [dbo].[tb_bp_batch_master] (
    [batch_id]              BIGINT         IDENTITY (1, 1) NOT NULL,
    [file_format]           NVARCHAR (20)  NOT NULL,
    [batch_state_master_id] INT            NOT NULL,
    [file_name]             NVARCHAR (100) NOT NULL,
    [created_date]          DATETIME       NOT NULL,
    [created_by]            NVARCHAR (100) NOT NULL,
    [updated_date]          DATETIME       NULL,
    [updated_by]            NVARCHAR (100) NULL,
    [batch_type_master_id]  INT            NOT NULL,
    [batch_number]          AS             (format([created_date],'yyyyMMdd')+format([batch_id],'00000')),
    CONSTRAINT [PK_tb_bp_batch_master_batch_id] PRIMARY KEY CLUSTERED ([batch_id] ASC),
    CONSTRAINT [FK_tb_bp_batch_state_master_tb_bp_batch_master_id] FOREIGN KEY ([batch_state_master_id]) REFERENCES [dbo].[tb_bp_batch_state_master] ([batch_state_master_id]),
    CONSTRAINT [FK_tb_bp_batch_type_master_tb_bp_batch_master] FOREIGN KEY ([batch_type_master_id]) REFERENCES [dbo].[tb_bp_batch_type_master] ([batch_type_master_id])
);

