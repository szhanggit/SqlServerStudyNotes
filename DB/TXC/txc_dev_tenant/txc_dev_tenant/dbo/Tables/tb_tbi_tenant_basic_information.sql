CREATE TABLE [dbo].[tb_tbi_tenant_basic_information] (
    [tenant_basic_info_id] INT           IDENTITY (1, 1) NOT NULL,
    [name]                 VARCHAR (100) NOT NULL,
    [country_code]         VARCHAR (5)   NOT NULL,
    [timezone]             VARCHAR (100) NOT NULL,
    [time_format]          VARCHAR (20)  NOT NULL,
    [currency_symbol]      VARCHAR (5)   NOT NULL,
    [company_tax_type]     BIT           NOT NULL,
    [logo]                 VARCHAR (MAX) NULL,
    [preferred_language]   VARCHAR (100) NULL,
    [is_active]            BIT           NULL,
    CONSTRAINT [PK_tb_tbi_tenant_basic_information] PRIMARY KEY CLUSTERED ([tenant_basic_info_id] ASC)
);

