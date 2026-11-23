CREATE TABLE [redemption].[tb_r_redeem] (
    [id]                  BIGINT         IDENTITY (1, 1) NOT NULL,
    [state_transition_id] SMALLINT       NOT NULL,
    [voucher_id]          BIGINT         NOT NULL,
    [pos_id]              INT            NOT NULL,
    [batch_id]            INT            NULL,
    [request_amount]      BIGINT         NOT NULL,
    [terminal_ssn]        VARCHAR (50)   NULL,
    [tran_code]           NVARCHAR (90)  NOT NULL,
    [tran_code_ref]       NVARCHAR (90)  NULL,
    [shift_code]          VARCHAR (50)   NULL,
    [business_day]        INT            NULL,
    [rsv1]                NVARCHAR (255) NULL,
    [rsv2]                NVARCHAR (255) NULL,
    [rsv3]                NVARCHAR (255) NULL,
    [partition_date]      INT            NOT NULL,
    [received_datetime]   DATETIME       NOT NULL,
    [is_completed]        BIT            NOT NULL,
    CONSTRAINT [PK_tb_r_redeem] PRIMARY KEY NONCLUSTERED ([id] ASC) ON [PRIMARY],
    CONSTRAINT [FK_tb_r_redeem_tb_b_batch_batchId] FOREIGN KEY ([batch_id]) REFERENCES [redemption].[tb_b_batch] ([id]),
    CONSTRAINT [FK_tb_r_redeem_tb_p_pos_posId] FOREIGN KEY ([pos_id]) REFERENCES [redemption].[tb_p_pos] ([id]),
    CONSTRAINT [UK_tb_r_redeem_posId_terminalSsn] UNIQUE NONCLUSTERED ([pos_id] ASC, [terminal_ssn] ASC, [partition_date] ASC) ON [DateRangePartitionScheme15K] ([partition_date]),
    CONSTRAINT [UK_tb_r_redeem_tranCode] UNIQUE NONCLUSTERED ([tran_code] ASC, [partition_date] ASC) ON [DateRangePartitionScheme15K] ([partition_date])
) ON [DateRangePartitionScheme15K] ([partition_date]);


GO
CREATE NONCLUSTERED INDEX [IDX_tb_r_redeem_voucherId_stateTransitionId]
    ON [redemption].[tb_r_redeem]([voucher_id] ASC, [state_transition_id] ASC)
    INCLUDE([id], [pos_id], [received_datetime])
    ON [DateRangePartitionScheme15K] ([partition_date]);

