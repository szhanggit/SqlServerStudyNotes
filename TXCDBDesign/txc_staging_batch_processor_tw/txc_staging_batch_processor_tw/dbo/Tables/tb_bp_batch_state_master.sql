CREATE TABLE [dbo].[tb_bp_batch_state_master] (
    [batch_state_master_id] INT            IDENTITY (1, 1) NOT NULL,
    [description]           NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_tb_bp_batch_state_master_batch_state_master_id] PRIMARY KEY CLUSTERED ([batch_state_master_id] ASC)
);

