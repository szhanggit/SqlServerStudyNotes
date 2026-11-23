CREATE TABLE [dbo].[tb_oom_order_operation_master] (
    [id]        INT           IDENTITY (1, 1) NOT NULL,
    [name]      NVARCHAR (50) NOT NULL,
    [timestamp] ROWVERSION    NOT NULL,
    CONSTRAINT [PK_tb_oom_order_operation_master] PRIMARY KEY CLUSTERED ([id] ASC)
);

