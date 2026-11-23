CREATE TABLE [dbo].[tb_r_role] (
    [role_id]     INT            IDENTITY (1, 1) NOT NULL,
    [role_name]   NVARCHAR (100) NOT NULL,
    [description] NVARCHAR (255) NULL,
    [is_enabled]  BIT            NOT NULL,
    [tenant_id]   INT            NULL,
    [app_id]      INT            NULL,
    [is_admin]    BIT            NOT NULL,
    CONSTRAINT [PK_tb_r_role] PRIMARY KEY CLUSTERED ([role_id] ASC),
    CONSTRAINT [FK_tb_r_role_tb_a_app] FOREIGN KEY ([app_id]) REFERENCES [dbo].[tb_a_app] ([app_id]),
    CONSTRAINT [FK_tb_r_role_tb_t_tenant] FOREIGN KEY ([tenant_id]) REFERENCES [dbo].[tb_t_tenant] ([tenant_id])
);

