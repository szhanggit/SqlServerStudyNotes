CREATE TABLE [voucher].[tb_vl_voucher_log] (
    [id]                          BIGINT   IDENTITY (1, 1) NOT NULL,
    [voucher_id]                  BIGINT   NOT NULL,
    [voucher_id_partition_number] INT      NOT NULL,
    [state_transition_id]         SMALLINT NOT NULL,
    [reference_date]              DATETIME NULL,
    [created_on]                  DATETIME NOT NULL,
    PRIMARY KEY NONCLUSTERED ([id] ASC) ON [PRIMARY],
    CONSTRAINT [FK_voucher_log_state_transition] FOREIGN KEY ([state_transition_id]) REFERENCES [voucher].[tb_vst_voucher_state_transition] ([id]),
    CONSTRAINT [FK_voucher_log_voucher] FOREIGN KEY ([voucher_id]) REFERENCES [voucher].[tb_v_voucher] ([id])
) ON [RangeParitionScheme10K] ([voucher_id_partition_number]);

