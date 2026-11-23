CREATE TABLE [dbo].[DistributionTaskMessageVoucher] (
    [Id]                        BIGINT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [DistributionTaskMessageId] BIGINT NOT NULL,
    [VoucherId]                 BIGINT NOT NULL,
    CONSTRAINT [PK_DistributionTaskMessageVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_DistributionTaskMessageVoucher_DistributionTaskMessage_DistributionTaskMessageId] FOREIGN KEY ([DistributionTaskMessageId]) REFERENCES [dbo].[DistributionTaskMessage] ([Id]),
    CONSTRAINT [FK_DistributionTaskMessageVoucher_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [DTMId_DTMV_Index]
    ON [dbo].[DistributionTaskMessageVoucher]([DistributionTaskMessageId] ASC);


GO
CREATE NONCLUSTERED INDEX [VoucherId_DTMV_Index]
    ON [dbo].[DistributionTaskMessageVoucher]([VoucherId] ASC);

