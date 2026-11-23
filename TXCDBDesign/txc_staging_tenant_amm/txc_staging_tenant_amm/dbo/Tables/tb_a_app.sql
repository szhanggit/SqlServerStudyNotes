CREATE TABLE [dbo].[tb_a_app] (
    [app_id]         INT            IDENTITY (1, 1) NOT NULL,
    [app_code]       NVARCHAR (50)  NOT NULL,
    [app_key]        NVARCHAR (50)  NOT NULL,
    [app_name]       NVARCHAR (50)  NOT NULL,
    [description]    NVARCHAR (255) NULL,
    [is_enabled]     BIT            NOT NULL,
    [is_multitenant] BIT            NOT NULL,
    CONSTRAINT [PK_tb_a_app] PRIMARY KEY CLUSTERED ([app_id] ASC)
);

