CREATE TABLE [merchant_info].[tb_t_terminal] (
    [id]            INT           IDENTITY (1, 1) NOT NULL,
    [shop_id]       INT           NOT NULL,
    [identity_code] NVARCHAR (50) NOT NULL,
    [external_code] NVARCHAR (50) NULL,
    [security_key]  NVARCHAR (48) NOT NULL,
    [status]        TINYINT       NULL,
    [created_on]    DATETIME      NULL,
    [created_by]    NVARCHAR (50) NOT NULL,
    [work_key_id]   INT           NULL,
    CONSTRAINT [PK_tb_t_terminal] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [comp_uk_tb_t_terminal_identity_code_shop_id] UNIQUE NONCLUSTERED ([identity_code] ASC, [shop_id] ASC)
);

