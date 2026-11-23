CREATE TABLE [dbo].[tb_tc_tenant_config] (
    [tenantconfig_id] INT             IDENTITY (1, 1) NOT NULL,
    [tenant_id]       INT             NOT NULL,
    [configtype]      NVARCHAR (128)  NOT NULL,
    [configname]      NVARCHAR (128)  NOT NULL,
    [version]         NVARCHAR (10)   NULL,
    [value]           NVARCHAR (128)  NULL,
    [comment]         NVARCHAR (1000) NULL,
    [creation_time]   DATETIME        NULL,
    PRIMARY KEY CLUSTERED ([tenantconfig_id] ASC),
    CONSTRAINT [FK_TENANTCONFIG_REF_TENANT] FOREIGN KEY ([tenant_id]) REFERENCES [dbo].[tb_tbi_tenant_basic_information] ([tenant_basic_info_id])
);

