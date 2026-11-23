CREATE TABLE [dbo].[tb_p_permission] (
    [permission_id] INT            IDENTITY (1, 1) NOT NULL,
    [description]   NVARCHAR (255) NULL,
    [role_id]       INT            NOT NULL,
    [operation_id]  INT            NOT NULL,
    CONSTRAINT [PK_tb_p_permission] PRIMARY KEY CLUSTERED ([role_id] ASC, [operation_id] ASC),
    CONSTRAINT [FK_tb_p_permission_tb_o_operation] FOREIGN KEY ([operation_id]) REFERENCES [dbo].[tb_o_operation] ([operation_id]),
    CONSTRAINT [FK_tb_p_permission_tb_r_role] FOREIGN KEY ([role_id]) REFERENCES [dbo].[tb_r_role] ([role_id])
);

