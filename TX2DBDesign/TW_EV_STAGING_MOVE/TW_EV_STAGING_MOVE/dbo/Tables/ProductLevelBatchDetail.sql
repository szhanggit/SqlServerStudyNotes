CREATE TABLE [dbo].[ProductLevelBatchDetail] (
    [Id]                   BIGINT          IDENTITY (1, 1) NOT NULL,
    [ProductLevelBatchId]  BIGINT          NOT NULL,
    [ProductCode]          VARCHAR (50)    NULL,
    [FaceValue]            DECIMAL (10, 4) NULL,
    [InstockHighWatermark] INT             NULL,
    [ProcurementQty]       INT             NULL,
    [CacheHighWatermark]   INT             NULL,
    [CacheLowWatermark]    INT             NULL,
    [Reason]               NVARCHAR (100)  NULL,
    [ResponseCode]         VARCHAR (5)     NULL,
    CONSTRAINT [PK_ProductLevelBatchDetail] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ProductLevelBatchDetail_ProductLevelBatch] FOREIGN KEY ([ProductLevelBatchId]) REFERENCES [dbo].[ProductLevelBatch] ([Id])
);

