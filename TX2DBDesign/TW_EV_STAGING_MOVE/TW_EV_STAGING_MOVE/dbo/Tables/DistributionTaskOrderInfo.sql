CREATE TABLE [dbo].[DistributionTaskOrderInfo] (
    [Id]                 BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [DistributionTaskId] BIGINT          NULL,
    [OrderId]            INT             NOT NULL,
    [FileName]           NVARCHAR (255)  NULL,
    [DistributionStatus] TINYINT         NOT NULL,
    [Memo]               NVARCHAR (1000) NULL,
    [CreatedOn]          DATETIME        NOT NULL,
    [CreatedBy]          NVARCHAR (100)  NOT NULL,
    CONSTRAINT [PK_DISTRIBUTIONTASKORDERINFO] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_DistributionTaskOrderInfo_DistributionTask_DistributionTaskId] FOREIGN KEY ([DistributionTaskId]) REFERENCES [dbo].[DistributionTask] ([Id]),
    CONSTRAINT [FK_DistributionTaskOrderInfo_Order_OrderId] FOREIGN KEY ([OrderId]) REFERENCES [dbo].[Order] ([Id])
);

