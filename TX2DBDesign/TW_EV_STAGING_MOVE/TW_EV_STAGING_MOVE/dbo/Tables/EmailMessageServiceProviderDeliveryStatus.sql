CREATE TABLE [dbo].[EmailMessageServiceProviderDeliveryStatus] (
    [Id]             BIGINT        IDENTITY (1, 1) NOT NULL,
    [VoucherId]      BIGINT        NOT NULL,
    [DeliveryStatus] NVARCHAR (50) NOT NULL,
    [DeliveryTime]   DATETIME      NOT NULL,
    [CreatedTime]    DATETIME      NOT NULL,
    CONSTRAINT [PK_EmailMessageServiceProviderDeliveryStatus_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_EmailMessageServiceProviderDeliveryStatus_VoucherId]
    ON [dbo].[EmailMessageServiceProviderDeliveryStatus]([VoucherId] DESC)
    INCLUDE([DeliveryStatus]);


GO
CREATE NONCLUSTERED INDEX [IDX_EmailMessageServiceProviderDeliveryStatus_CreatedTime]
    ON [dbo].[EmailMessageServiceProviderDeliveryStatus]([DeliveryTime] DESC);

