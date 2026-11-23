CREATE TABLE [redemption].[tb_rr_reference_redeem] (
    [id]               BIGINT IDENTITY (1, 1) NOT NULL,
    [redeem_id]        BIGINT NOT NULL,
    [ref_redeem_id]    BIGINT NOT NULL,
    [partition_number] INT    NOT NULL,
    CONSTRAINT [PK_tb_rr_reference_redeem] PRIMARY KEY NONCLUSTERED ([id] ASC) ON [PRIMARY],
    CONSTRAINT [FK_tb_rr_reference_redeem_tb_r_redeem_redeemId] FOREIGN KEY ([redeem_id]) REFERENCES [redemption].[tb_r_redeem] ([id]),
    CONSTRAINT [FK_tb_rr_reference_redeem_tb_r_redeem_refRedeemId] FOREIGN KEY ([ref_redeem_id]) REFERENCES [redemption].[tb_r_redeem] ([id])
) ON [RangePartitionScheme1K] ([partition_number]);


GO
CREATE NONCLUSTERED INDEX [IDX_tb_rr_reference_redeem_refRedeemId_partitionNumber]
    ON [redemption].[tb_rr_reference_redeem]([ref_redeem_id] ASC, [partition_number] ASC)
    ON [RangePartitionScheme1K] ([partition_number]);

