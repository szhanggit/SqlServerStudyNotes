CREATE TABLE [dbo].[SLMSMessageServiceProviderDeliveryStatus] (
    [Id]             BIGINT        IDENTITY (1, 1) NOT NULL,
    [VoucherId]      BIGINT        NOT NULL,
    [DeliveryStatus] NVARCHAR (50) NOT NULL,
    [DeliveryTime]   DATETIME      NOT NULL,
    [CreatedTime]    DATETIME      NOT NULL,
    CONSTRAINT [PK_SLMSMessageServiceProviderDeliveryStatus_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_SLMSMessageServiceProviderDeliveryStatus_VoucherId]
    ON [dbo].[SLMSMessageServiceProviderDeliveryStatus]([VoucherId] DESC)
    INCLUDE([DeliveryStatus]);


GO
CREATE NONCLUSTERED INDEX [IDX_SLMSMessageServiceProviderDeliveryStatus_CreatedTime]
    ON [dbo].[SLMSMessageServiceProviderDeliveryStatus]([DeliveryTime] DESC);

