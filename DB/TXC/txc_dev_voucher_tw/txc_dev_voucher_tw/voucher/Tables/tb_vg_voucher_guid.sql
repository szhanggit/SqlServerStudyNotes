CREATE TABLE [voucher].[tb_vg_voucher_guid] (
    [voucher_id]       BIGINT           NOT NULL,
    [guid]             UNIQUEIDENTIFIER NOT NULL,
    [partition_number] INT              NOT NULL,
    PRIMARY KEY NONCLUSTERED ([voucher_id] ASC) ON [PRIMARY],
    CONSTRAINT [FK_voucher_guid_voucher] FOREIGN KEY ([voucher_id]) REFERENCES [voucher].[tb_v_voucher] ([id])
) ON [RangeParitionScheme10K] ([partition_number]);

