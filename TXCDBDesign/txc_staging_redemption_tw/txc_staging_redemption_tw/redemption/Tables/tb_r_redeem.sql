CREATE TABLE [redemption].[tb_r_redeem] (
    [id]                                      BIGINT         IDENTITY (1, 1) NOT NULL,
    [state_transition_id]                     SMALLINT       NOT NULL,
    [voucher_id]                              BIGINT         NOT NULL,
    [pos_id]                                  INT            NOT NULL,
    [request_amount]                          BIGINT         NOT NULL,
    [remaining_voucher_balance_after_request] BIGINT         NOT NULL,
    [terminal_ssn]                            VARCHAR (50)   NULL,
    [tran_code]                               VARCHAR (90)   NOT NULL,
    [tran_code_ref]                           VARCHAR (90)   NULL,
    [shift_code]                              VARCHAR (50)   NULL,
    [business_day]                            INT            NULL,
    [rsv1]                                    NVARCHAR (255) NULL,
    [rsv2]                                    NVARCHAR (255) NULL,
    [rsv3]                                    NVARCHAR (255) NULL,
    [received_datetime]                       DATETIME       NOT NULL,
    [batch_id]                                BIGINT         NULL,
    [is_completed]                            BIT            NOT NULL,
    [row_version]                             ROWVERSION     NOT NULL,
    CONSTRAINT [PK_tb_r_redeem] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_tb_r_redeem_tb_b_batch_batchId] FOREIGN KEY ([batch_id]) REFERENCES [redemption].[tb_b_batch] ([id]),
    CONSTRAINT [FK_tb_r_redeem_tb_p_pos_posId] FOREIGN KEY ([pos_id]) REFERENCES [redemption].[tb_p_pos] ([id]),
    CONSTRAINT [UK_tb_r_redeem_tranCode] UNIQUE NONCLUSTERED ([tran_code] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_tb_r_redeem_tranCodeRef]
    ON [redemption].[tb_r_redeem]([tran_code_ref] ASC) WHERE ([tran_code_ref] IS NOT NULL);


GO
CREATE NONCLUSTERED INDEX [IDX_tb_r_redeem_batchId]
    ON [redemption].[tb_r_redeem]([batch_id] ASC)
    INCLUDE([id]);


GO
CREATE NONCLUSTERED INDEX [IDX_tb_r_redeem_posId_voucherId_terminalSsn]
    ON [redemption].[tb_r_redeem]([pos_id] ASC, [voucher_id] ASC, [terminal_ssn] ASC)
    INCLUDE([id]);


GO
CREATE NONCLUSTERED INDEX [IDX_tb_r_redeem_voucherId]
    ON [redemption].[tb_r_redeem]([voucher_id] ASC)
    INCLUDE([id]);

