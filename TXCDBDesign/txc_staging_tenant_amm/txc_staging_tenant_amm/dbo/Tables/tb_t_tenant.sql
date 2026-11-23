CREATE TABLE [dbo].[tb_t_tenant] (
    [tenant_id]   INT            NOT NULL,
    [tenant_code] NVARCHAR (50)  NOT NULL,
    [tenant_name] NVARCHAR (100) NOT NULL,
    [is_enabled]  BIT            NOT NULL,
    CONSTRAINT [PK_tb_t_tenant] PRIMARY KEY CLUSTERED ([tenant_id] ASC)
);

