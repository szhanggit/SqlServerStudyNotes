CREATE TABLE [dbo].[tb_uh_user_history] (
    [uh_id]           INT            IDENTITY (1, 1) NOT NULL,
    [user_id]         INT            NOT NULL,
    [update_datetime] DATETIME       NOT NULL,
    [editor]          NVARCHAR (255) NULL,
    [app_id]          INT            NOT NULL,
    [tenant_id]       INT            NOT NULL,
    [action]          NVARCHAR (255) NOT NULL,
    [details]         NVARCHAR (255) NULL,
    [active_date]     DATETIME       NULL,
    [expiration_date] DATETIME       NULL,
    CONSTRAINT [PK_tb_rc_role_category] PRIMARY KEY CLUSTERED ([uh_id] ASC),
    CONSTRAINT [FK_tb_uh_user_history_tb_a_app] FOREIGN KEY ([app_id]) REFERENCES [dbo].[tb_a_app] ([app_id]),
    CONSTRAINT [FK_tb_uh_user_historytb_t_tenant] FOREIGN KEY ([tenant_id]) REFERENCES [dbo].[tb_t_tenant] ([tenant_id])
);

