CREATE TABLE [voucher].[tb_vad_voucher_attribute_definition] (
    [id]             TINYINT      NOT NULL,
    [attribute_name] VARCHAR (50) NOT NULL,
    [row_version]    ROWVERSION   NOT NULL,
    CONSTRAINT [PK_voucher_attribute_definition_id] PRIMARY KEY CLUSTERED ([id] ASC)
);

