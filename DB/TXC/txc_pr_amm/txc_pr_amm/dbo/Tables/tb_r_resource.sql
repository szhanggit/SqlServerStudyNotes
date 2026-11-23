CREATE TABLE [dbo].[tb_r_resource] (
    [resource_id]   INT            IDENTITY (1, 1) NOT NULL,
    [resource_code] NVARCHAR (50)  NOT NULL,
    [resource_name] NVARCHAR (50)  NOT NULL,
    [description]   NVARCHAR (255) NULL,
    [is_enabled]    BIT            NOT NULL,
    [module_id]     INT            NOT NULL,
    CONSTRAINT [PK_tb_r_resource] PRIMARY KEY CLUSTERED ([resource_id] ASC),
    CONSTRAINT [FK_tb_r_resource_tb_m_module] FOREIGN KEY ([module_id]) REFERENCES [dbo].[tb_m_module] ([module_id])
);

