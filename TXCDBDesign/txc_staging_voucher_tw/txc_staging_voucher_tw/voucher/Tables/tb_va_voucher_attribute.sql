CREATE TABLE [voucher].[tb_va_voucher_attribute] (
    [voucher_id]   BIGINT         NOT NULL,
    [attribute_id] TINYINT        NOT NULL,
    [value]        NVARCHAR (500) NOT NULL,
    [row_version]  ROWVERSION     NOT NULL,
    CONSTRAINT [PK_voucher_attribute_voucher_id_attribute_id] PRIMARY KEY CLUSTERED ([voucher_id] ASC, [attribute_id] ASC),
    CONSTRAINT [FK_voucher_attribute_attribute_id] FOREIGN KEY ([attribute_id]) REFERENCES [voucher].[tb_vad_voucher_attribute_definition] ([id]),
    CONSTRAINT [FK_voucher_attribute_voucher_id] FOREIGN KEY ([voucher_id]) REFERENCES [voucher].[tb_v_voucher] ([id])
);


GO
CREATE NONCLUSTERED INDEX [IX_voucher_attribute_key_value]
    ON [voucher].[tb_va_voucher_attribute]([attribute_id] ASC, [value] ASC);

