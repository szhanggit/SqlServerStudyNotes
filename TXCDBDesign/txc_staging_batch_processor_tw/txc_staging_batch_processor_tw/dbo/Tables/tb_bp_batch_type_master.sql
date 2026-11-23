CREATE TABLE [dbo].[tb_bp_batch_type_master] (
    [batch_type_master_id] INT           IDENTITY (1, 1) NOT NULL,
    [batch_name]           NVARCHAR (20) NOT NULL,
    [tenant_id]            INT           NOT NULL,
    [workflow]             INT           NOT NULL,
    CONSTRAINT [PK_tb_bp_batch_type_master_batch_type_master_id] PRIMARY KEY CLUSTERED ([batch_type_master_id] ASC)
);

