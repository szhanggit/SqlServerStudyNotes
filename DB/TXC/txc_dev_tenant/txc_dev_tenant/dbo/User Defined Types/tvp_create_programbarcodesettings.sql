CREATE TYPE [dbo].[tvp_create_programbarcodesettings] AS TABLE (
    [barcode_index]           INT          NULL,
    [barcode_type]            VARCHAR (20) NULL,
    [is_barcode_display_text] BIT          NULL,
    [is_barcode_api_enabled]  BIT          NULL);

