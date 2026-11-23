CREATE TABLE [quotation].[tb_qp_quotation_product] (
    [id]                       INT             IDENTITY (1, 1) NOT NULL,
    [quotation_id]             INT             NOT NULL,
    [product_version_id]       INT             NOT NULL,
    [expiry_scheme_id]         INT             NOT NULL,
    [max_issue_voucher_number] INT             NULL,
    [system_process_fee]       NUMERIC (15, 4) NOT NULL,
    [expiration_date]          DATETIME        NULL,
    [enable_customization]     BIT             NULL,
    [status]                   INT             NOT NULL,
    [created_by]               NVARCHAR (50)   NOT NULL,
    [created_on]               DATETIME        NOT NULL,
    [approved_by]              NVARCHAR (50)   NULL,
    [approved_on]              DATETIME        NULL,
    [updated_by]               NVARCHAR (50)   NULL,
    [updated_on]               DATETIME        NULL,
    [child_status]             INT             NULL,
    [product_code]             NVARCHAR (50)   NULL,
    CONSTRAINT [PK_tb_qp_quotation_product] PRIMARY KEY CLUSTERED ([id] ASC)
);

