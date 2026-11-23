CREATE TABLE [backup].[tb_contract_sku] (
    [id]                     INT             IDENTITY (1, 1) NOT NULL,
    [sku_name]               NVARCHAR (128)  NOT NULL,
    [sku_number]             NVARCHAR (128)  NOT NULL,
    [type_id]                INT             NOT NULL,
    [face_value_with_tax]    DECIMAL (18, 2) NULL,
    [voucher_number_rule_id] INT             NULL,
    [created_by]             NVARCHAR (50)   NULL,
    [created_datetime]       DATETIME        NULL,
    [merchant_group_id]      INT             NULL,
    [face_value_without_tax] DECIMAL (20, 4) NULL,
    [multiplier]             INT             NULL,
    [updated_by]             NVARCHAR (50)   NULL,
    [updated_datetime]       DATETIME        NULL
);

