CREATE TABLE [merchant_info].[tb_ic_imported_columns] (
    [id]                    INT            IDENTITY (1, 1) NOT NULL,
    [imported_file_id]      INT            NOT NULL,
    [seq]                   TINYINT        NOT NULL,
    [column_name]           NVARCHAR (100) NOT NULL,
    [template_tag_name]     NVARCHAR (100) NULL,
    [is_voucher_number]     BIT            NOT NULL,
    [barcode_type_id]       INT            NULL,
    [is_shown_barcode_text] BIT            NOT NULL,
    [is_hidden]             BIT            NOT NULL,
    CONSTRAINT [PK_import_property] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UX_imported_file_id_column_name] UNIQUE NONCLUSTERED ([imported_file_id] ASC, [column_name] ASC)
);

