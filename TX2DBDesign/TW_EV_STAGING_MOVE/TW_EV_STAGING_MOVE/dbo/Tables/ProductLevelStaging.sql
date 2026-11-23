CREATE TABLE [dbo].[ProductLevelStaging] (
    [BatchId]              INT          NOT NULL,
    [ProductCode]          VARCHAR (50) NULL,
    [FaceValue]            DECIMAL (18) NULL,
    [InstockHighWatermark] INT          NULL,
    [ProcurementQty]       INT          NULL,
    [CacheHighWatermark]   INT          NULL,
    [CacheLowWatermark]    INT          NULL,
    [CreatedTime]          DATETIME     NOT NULL
);

