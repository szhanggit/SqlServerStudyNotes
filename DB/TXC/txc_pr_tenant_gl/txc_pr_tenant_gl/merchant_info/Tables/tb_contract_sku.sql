CREATE TABLE [merchant_info].[tb_contract_sku] (
    [id]                     INT             IDENTITY (1, 1) NOT NULL,
    [sku_name]               NVARCHAR (200)  NOT NULL,
    [sku_number]             NVARCHAR (128)  NOT NULL,
    [type_id]                INT             NOT NULL,
    [face_value_with_tax]    DECIMAL (18, 2) NULL,
    [voucher_number_rule_id] INT             NOT NULL,
    [created_by]             NVARCHAR (50)   NULL,
    [created_datetime]       DATETIME        NULL,
    [face_value_without_tax] DECIMAL (20, 4) NULL,
    [merchant_group_id]      INT             NULL,
    [multiplier]             INT             NULL,
    [updated_by]             NVARCHAR (50)   NULL,
    [updated_datetime]       DATETIME        NULL,
    [timestamp]              ROWVERSION      NOT NULL,
    CONSTRAINT [pk_tb_contract_sku] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_contract_sku_type] FOREIGN KEY ([type_id]) REFERENCES [merchant_info].[tb_contract_sku_type] ([id]),
    CONSTRAINT [FK_sku_vnr_voucher_number_rule] FOREIGN KEY ([voucher_number_rule_id]) REFERENCES [merchant_info].[tb_vnr_voucher_number_rule] ([id]),
    CONSTRAINT [FK_tb_contract_sku_tb_mg_merchant_group] FOREIGN KEY ([merchant_group_id]) REFERENCES [merchant_info].[tb_mg_merchant_group] ([merchant_group_id])
);

