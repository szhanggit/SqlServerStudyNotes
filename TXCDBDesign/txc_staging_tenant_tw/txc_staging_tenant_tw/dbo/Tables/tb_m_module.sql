CREATE TABLE [dbo].[tb_m_module] (
    [module_id]   INT            IDENTITY (1, 1) NOT NULL,
    [module_code] NVARCHAR (50)  NOT NULL,
    [module_name] NVARCHAR (50)  NOT NULL,
    [description] NVARCHAR (255) NULL,
    [app_id]      INT            NOT NULL,
    CONSTRAINT [PK_tb_m_module] PRIMARY KEY CLUSTERED ([module_id] ASC),
    CONSTRAINT [FK_tb_m_module_tb_a_app] FOREIGN KEY ([app_id]) REFERENCES [dbo].[tb_a_app] ([app_id])
);

