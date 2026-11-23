CREATE TABLE [voucher].[tb_td_transition_denormalized] (
    [id]                          BIGINT         IDENTITY (1, 1) NOT NULL,
    [voucher_id]                  BIGINT         NOT NULL,
    [voucher_id_partition_number] INT            NOT NULL,
    [merchant_id]                 INT            NULL,
    [shop_id]                     INT            NULL,
    [amount]                      BIGINT         NULL,
    [action_time]                 DATETIME       NOT NULL,
    [action]                      VARCHAR (50)   NOT NULL,
    [tran_code]                   NVARCHAR (90)  NULL,
    [operator]                    VARCHAR (50)   NULL,
    [rsv1]                        NVARCHAR (255) NULL,
    [business_date]               DATETIME       NULL,
    PRIMARY KEY NONCLUSTERED ([id] ASC) ON [PRIMARY],
    CONSTRAINT [FK_voucher_id] FOREIGN KEY ([voucher_id]) REFERENCES [voucher].[tb_v_voucher] ([id])
) ON [RangeParitionScheme10K] ([voucher_id_partition_number]);

