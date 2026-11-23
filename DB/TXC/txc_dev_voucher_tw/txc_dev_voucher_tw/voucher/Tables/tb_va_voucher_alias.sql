CREATE TABLE [voucher].[tb_va_voucher_alias] (
    [voucher_id]       BIGINT       NOT NULL,
    [alias]            VARCHAR (50) NOT NULL,
    [partition_number] INT          NOT NULL,
    PRIMARY KEY NONCLUSTERED ([voucher_id] ASC) ON [PRIMARY],
    CONSTRAINT [FK_voucher_alias_voucher] FOREIGN KEY ([voucher_id]) REFERENCES [voucher].[tb_v_voucher] ([id]),
    CONSTRAINT [UK_voucher_alias] UNIQUE NONCLUSTERED ([alias] ASC, [partition_number] ASC) ON [RangeParitionScheme10K] ([partition_number])
) ON [RangeParitionScheme10K] ([partition_number]);

