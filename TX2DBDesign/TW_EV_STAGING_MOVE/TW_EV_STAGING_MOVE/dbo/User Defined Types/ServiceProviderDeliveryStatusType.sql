CREATE TYPE [dbo].[ServiceProviderDeliveryStatusType] AS TABLE (
    [DistributionTaskMessageId] BIGINT        NULL,
    [DeliveryStatus]            NVARCHAR (50) NULL,
    [DeliveryTime]              DATETIME      NULL);

