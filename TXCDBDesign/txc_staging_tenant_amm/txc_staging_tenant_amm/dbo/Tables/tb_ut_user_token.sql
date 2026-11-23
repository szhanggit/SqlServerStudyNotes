CREATE TABLE [dbo].[tb_ut_user_token] (
    [user_token_id]     BIGINT          IDENTITY (1, 1) NOT NULL,
    [user_id]           INT             NULL,
    [access_token]      NVARCHAR (1000) NOT NULL,
    [refresh_token]     NVARCHAR (1000) NOT NULL,
    [app_id]            INT             NOT NULL,
    [refresh_token_exp] DATETIME        NOT NULL,
    [is_active]         BIT             NOT NULL,
    [created_on]        DATETIME        NOT NULL,
    CONSTRAINT [PK_tb_ut_user_token] PRIMARY KEY CLUSTERED ([user_token_id] ASC),
    CONSTRAINT [FK_tb_ut_user_token_tb_u_user] FOREIGN KEY ([user_id]) REFERENCES [dbo].[tb_u_user] ([user_id])
);

