CREATE TABLE [inventory].[tb_s_sku_temp] (
    [sku_id]                      INT            IDENTITY (1, 1) NOT NULL,
    [merchant_id]                 INT            NOT NULL,
    [sku_code]                    VARCHAR (50)   NOT NULL,
    [sku_name]                    NVARCHAR (100) NOT NULL,
    [description]                 NVARCHAR (500) NULL,
    [voucher_number_rule_id]      INT            NULL,
    [brand_type]                  TINYINT        NOT NULL,
    [face_value_with_tax_cent]    BIGINT         NOT NULL,
    [face_value_without_tax_cent] BIGINT         NOT NULL,
    [smart_booklet_multiplier]    INT            NULL,
    CONSTRAINT [PK_tb_s_sku_temp] PRIMARY KEY CLUSTERED ([sku_id] ASC)
);

