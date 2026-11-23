CREATE TABLE [voucher].[tb_em_extension_mapping] (
    [id]                    INT            IDENTITY (1, 1) NOT NULL,
    [voucher_generator_id]  INT            NOT NULL,
    [column_name]           NVARCHAR (100) NOT NULL,
    [template_tag_name]     NVARCHAR (100) NULL,
    [barcode_type_id]       INT            NULL,
    [is_shown_barcode_text] BIT            NOT NULL,
    [is_hidden]             BIT            NOT NULL,
    [created_by]            NVARCHAR (50)  NOT NULL,
    [created_datetime]      DATETIME       NOT NULL,
    [updated_by]            NVARCHAR (50)  NULL,
    [updated_datetime]      DATETIME       NULL,
    [status]                TINYINT        NULL,
    CONSTRAINT [PK_import_property] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UX_voucher_generator_id_column_name] UNIQUE NONCLUSTERED ([voucher_generator_id] ASC, [column_name] ASC)
);

