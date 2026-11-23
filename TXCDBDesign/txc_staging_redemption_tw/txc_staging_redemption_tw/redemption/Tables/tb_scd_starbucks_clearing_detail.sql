CREATE TABLE [redemption].[tb_scd_starbucks_clearing_detail] (
    [id]           BIGINT       NOT NULL,
    [clearing_id]  BIGINT       NOT NULL,
    [terminal_ssn] VARCHAR (50) NULL,
    [tran_code]    VARCHAR (90) NULL,
    [voucher_id]   BIGINT       NULL,
    [redeem_id]    BIGINT       NULL,
    CONSTRAINT [PK_tb_scd_starbucks_clearing_detail] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_tb_scd_starbucks_clearing_detail_r_redeem] FOREIGN KEY ([redeem_id]) REFERENCES [redemption].[tb_r_redeem] ([id]),
    CONSTRAINT [FK_tb_scd_starbucks_clearing_detail_sc_starbucks_clearing] FOREIGN KEY ([clearing_id]) REFERENCES [redemption].[tb_sc_starbucks_clearing] ([id])
);

