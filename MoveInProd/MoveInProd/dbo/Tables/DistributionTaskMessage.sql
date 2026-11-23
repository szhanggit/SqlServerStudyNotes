CREATE TABLE [dbo].[DistributionTaskMessage] (
    [Id]                 BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [DistributionTaskId] BIGINT          NOT NULL,
    [VoucherId]          BIGINT          NULL,
    [DistributionStatus] TINYINT         NOT NULL,
    [Memo]               NVARCHAR (1000) NULL,
    CONSTRAINT [PK_DISTRIBUTIONTASKMESSAGE] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_DistributionTaskMessage_DistributionTask_DistributionTaskId] FOREIGN KEY ([DistributionTaskId]) REFERENCES [dbo].[DistributionTask] ([Id]),
    CONSTRAINT [FK_DistributionTaskMessage_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IDX_DistributionTaskMessage_DistributionTaskId]
    ON [dbo].[DistributionTaskMessage]([DistributionTaskId] ASC);

