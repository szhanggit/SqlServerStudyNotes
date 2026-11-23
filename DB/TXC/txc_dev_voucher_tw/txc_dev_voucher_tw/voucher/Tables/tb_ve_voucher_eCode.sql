CREATE TABLE [voucher].[tb_ve_voucher_eCode] (
    [voucher_id]       BIGINT        NOT NULL,
    [eCode]            VARCHAR (500) NOT NULL,
    [partition_number] INT           NOT NULL,
    PRIMARY KEY NONCLUSTERED ([voucher_id] ASC) ON [PRIMARY],
    CONSTRAINT [FK_voucher_eCode_voucher] FOREIGN KEY ([voucher_id]) REFERENCES [voucher].[tb_v_voucher] ([id]),
    CONSTRAINT [UK_voucher_eCode] UNIQUE NONCLUSTERED ([eCode] ASC, [partition_number] ASC) ON [RangeParitionScheme10K] ([partition_number])
) ON [RangeParitionScheme10K] ([partition_number]);

