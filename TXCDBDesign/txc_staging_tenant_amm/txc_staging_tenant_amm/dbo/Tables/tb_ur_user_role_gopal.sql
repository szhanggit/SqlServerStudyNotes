CREATE TABLE [dbo].[tb_ur_user_role_gopal] (
    [user_role_id]    INT            IDENTITY (1, 1) NOT NULL,
    [user_id]         INT            NOT NULL,
    [role_id]         INT            NOT NULL,
    [created_on]      DATETIME       NOT NULL,
    [expiration_date] DATETIME       NULL,
    [active_date]     DATETIME       NULL,
    [created_by]      NVARCHAR (250) NOT NULL,
    [role_status]     INT            NOT NULL,
    [is_assigned]     BIT            NOT NULL
);

