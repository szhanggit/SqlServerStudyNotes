CREATE TABLE [redemption].[tb_b_batch] (
    [id]                INT          IDENTITY (1, 1) NOT NULL,
    [pos_id]            INT          NOT NULL,
    [terminal_ssn]      VARCHAR (50) NULL,
    [partition_date]    INT          NOT NULL,
    [received_datetime] DATETIME     NOT NULL,
    CONSTRAINT [PK_tb_b_batch] PRIMARY KEY NONCLUSTERED ([id] ASC) ON [PRIMARY],
    CONSTRAINT [FK_tb_b_batch_tb_p_pos_posId] FOREIGN KEY ([pos_id]) REFERENCES [redemption].[tb_p_pos] ([id]),
    CONSTRAINT [UK_tb_b_batch_posId_terminalSsn] UNIQUE NONCLUSTERED ([pos_id] ASC, [terminal_ssn] ASC, [partition_date] ASC) ON [DateRangePartitionSchemeMonthly] ([partition_date])
) ON [DateRangePartitionSchemeMonthly] ([partition_date]);

