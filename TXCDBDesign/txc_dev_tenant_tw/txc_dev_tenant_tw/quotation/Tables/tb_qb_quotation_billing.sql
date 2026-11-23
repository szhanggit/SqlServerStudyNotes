CREATE TABLE [quotation].[tb_qb_quotation_billing] (
    [id]                           INT             IDENTITY (1, 1) NOT NULL,
    [quotation_id]                 INT             NOT NULL,
    [advance_billing]              BIT             NOT NULL,
    [billing_frequency]            INT             NOT NULL,
    [billing_date]                 INT             NOT NULL,
    [payment_term]                 INT             NOT NULL,
    [BBX_advance_billing]          BIT             NOT NULL,
    [auto_create_billing]          BIT             NOT NULL,
    [sales_email]                  NVARCHAR (255)  NULL,
    [is_created_fapaio]            BIT             NOT NULL,
    [is_BBX_advanced_billing]      BIT             NOT NULL,
    [is_auto_create_fapaio]        BIT             NOT NULL,
    [BBX_advancedB_billing_number] NVARCHAR (2000) NULL,
    [auto_create_fapaio_number]    NVARCHAR (2000) NULL,
    [advanced_billing_off_reason]  NVARCHAR (1000) NULL,
    CONSTRAINT [PK_tb_qb_quotation_billing] PRIMARY KEY CLUSTERED ([id] ASC)
);

