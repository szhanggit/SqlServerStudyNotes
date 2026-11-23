CREATE TABLE [product].[tb_p_product_barcode_setting] (
    [product_barcode_setting_id] INT          IDENTITY (1, 1) NOT NULL,
    [product_id]                 INT          NOT NULL,
    [barcode_index]              INT          NOT NULL,
    [barcode_type]               VARCHAR (20) NULL,
    [is_barcode_display_text]    BIT          NULL,
    [is_barcode_api_enabled]     BIT          NULL,
    CONSTRAINT [PK_product_barcode_setting_id] PRIMARY KEY CLUSTERED ([product_barcode_setting_id] ASC),
    CONSTRAINT [UK_product_id_barcode_index] UNIQUE NONCLUSTERED ([product_id] ASC, [barcode_index] ASC)
);

