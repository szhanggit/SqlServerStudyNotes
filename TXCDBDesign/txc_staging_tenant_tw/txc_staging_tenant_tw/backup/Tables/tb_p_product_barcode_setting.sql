CREATE TABLE [backup].[tb_p_product_barcode_setting] (
    [product_barcode_setting_id] INT          IDENTITY (1, 1) NOT NULL,
    [product_id]                 INT          NOT NULL,
    [barcode_index]              INT          NOT NULL,
    [barcode_type]               VARCHAR (20) NULL,
    [is_barcode_display_text]    BIT          NULL,
    [is_barcode_api_enabled]     BIT          NULL
);

