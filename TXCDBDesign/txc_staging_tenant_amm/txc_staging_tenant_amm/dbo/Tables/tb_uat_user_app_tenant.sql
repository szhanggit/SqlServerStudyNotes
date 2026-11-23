CREATE TABLE [dbo].[tb_uat_user_app_tenant] (
    [uat_id]          INT      IDENTITY (1, 1) NOT NULL,
    [user_id]         INT      NOT NULL,
    [app_id]          INT      NOT NULL,
    [tenant_id]       INT      NOT NULL,
    [created_on]      DATETIME NOT NULL,
    [expiration_date] DATETIME NULL,
    [active_date]     DATETIME NULL,
    [uat_status]      INT      NOT NULL,
    CONSTRAINT [PK_tb_uat_user_app_tenant] PRIMARY KEY CLUSTERED ([uat_id] ASC),
    CONSTRAINT [FK_tb_uat_user_app_tenant_tb_a_app] FOREIGN KEY ([app_id]) REFERENCES [dbo].[tb_a_app] ([app_id]),
    CONSTRAINT [FK_tb_uat_user_app_tenant_tb_t_tenant] FOREIGN KEY ([tenant_id]) REFERENCES [dbo].[tb_t_tenant] ([tenant_id]),
    CONSTRAINT [FK_tb_uat_user_app_tenant_tb_u_user] FOREIGN KEY ([user_id]) REFERENCES [dbo].[tb_u_user] ([user_id]),
    CONSTRAINT [UQ_tb_uat_user_app_tenant_user_id_app_id_tenant_id] UNIQUE NONCLUSTERED ([user_id] ASC, [app_id] ASC, [tenant_id] ASC)
);

