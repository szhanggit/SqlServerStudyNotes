CREATE TABLE [dbo].[tb_ur_user_role] (
    [user_role_id]    INT            IDENTITY (1, 1) NOT NULL,
    [user_id]         INT            NOT NULL,
    [role_id]         INT            NOT NULL,
    [created_on]      DATETIME       NOT NULL,
    [expiration_date] DATETIME       NULL,
    [active_date]     DATETIME       NULL,
    [created_by]      NVARCHAR (250) NOT NULL,
    [role_status]     INT            NOT NULL,
    [is_assigned]     BIT            NOT NULL,
    CONSTRAINT [PK_tb_ur_user_role] PRIMARY KEY CLUSTERED ([user_role_id] ASC),
    CONSTRAINT [FK_tb_ur_user_role_tb_r_role] FOREIGN KEY ([role_id]) REFERENCES [dbo].[tb_r_role] ([role_id]),
    CONSTRAINT [FK_tb_ur_user_role_tb_u_user] FOREIGN KEY ([user_id]) REFERENCES [dbo].[tb_u_user] ([user_id]),
    CONSTRAINT [UQ_tb_ur_user_role_user_id_role_id] UNIQUE NONCLUSTERED ([user_id] ASC, [role_id] ASC)
);

