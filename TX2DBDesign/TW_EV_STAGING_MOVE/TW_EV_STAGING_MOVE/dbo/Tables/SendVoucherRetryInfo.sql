CREATE TABLE [dbo].[SendVoucherRetryInfo] (
    [Id]                  INT           IDENTITY (1, 1) NOT NULL,
    [OrderId]             INT           NOT NULL,
    [VoucherId]           BIGINT        NULL,
    [VoucherNumber]       VARCHAR (50)  NULL,
    [ServiceProviderCode] VARCHAR (200) NOT NULL,
    [RequestId]           VARCHAR (50)  NULL,
    [MessageType]         TINYINT       NOT NULL,
    [TryCount]            INT           NOT NULL,
    [ResponseCode]        VARCHAR (50)  NULL,
    [CreatedTime]         DATETIME      NOT NULL,
    [UpdatedTime]         DATETIME      NOT NULL,
    CONSTRAINT [PK_SendVoucherRetryInfo] PRIMARY KEY CLUSTERED ([Id] ASC)
);

