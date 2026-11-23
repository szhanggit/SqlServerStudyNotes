CREATE TABLE [backup].[tb_contract] (
    [id]                      INT             IDENTITY (1, 1) NOT NULL,
    [contract_name]           NVARCHAR (128)  NOT NULL,
    [start_date]              DATETIME        NOT NULL,
    [end_date]                DATETIME        NOT NULL,
    [payment_term_id]         INT             NOT NULL,
    [price_option_id]         INT             NOT NULL,
    [cost_scheme_id]          INT             NOT NULL,
    [cost_percentage]         DECIMAL (18, 2) NULL,
    [cost_rounding_rule_id]   INT             NULL,
    [cost_rounding_places_id] INT             NULL,
    [sku_quantity]            INT             NOT NULL,
    [status_id]               INT             NOT NULL,
    [merchant_id]             INT             NOT NULL,
    [created_by]              NVARCHAR (50)   NULL,
    [created_datetime]        DATETIME        NULL,
    [contract_number]         VARCHAR (13)    NULL,
    [updated_by]              NVARCHAR (50)   NULL,
    [updated_datetime]        DATETIME        NULL
);

