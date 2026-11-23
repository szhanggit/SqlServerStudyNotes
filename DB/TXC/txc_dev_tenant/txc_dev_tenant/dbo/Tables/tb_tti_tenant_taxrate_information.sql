CREATE TABLE [dbo].[tb_tti_tenant_taxrate_information] (
    [tenant_tax_rate_info_id] INT             IDENTITY (1, 1) NOT NULL,
    [tenant_basic_info_id]    INT             NOT NULL,
    [effectivity_date]        DATETIME        NOT NULL,
    [company_tax_rate]        DECIMAL (18, 2) NOT NULL,
    [is_active]               BIT             NOT NULL,
    CONSTRAINT [PK_tb_tti_tenant_tax_information] PRIMARY KEY CLUSTERED ([tenant_tax_rate_info_id] ASC),
    CONSTRAINT [FK_tb_tti_tenant_taxrate_information_tb_tbi_tenant_basic_information] FOREIGN KEY ([tenant_basic_info_id]) REFERENCES [dbo].[tb_tbi_tenant_basic_information] ([tenant_basic_info_id])
);

