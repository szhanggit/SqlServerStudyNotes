CREATE TABLE [dbo].[VoucherBuffer] (
    [Id]                 BIGINT           IDENTITY (1, 1) NOT NULL,
    [OrderId]            INT              NOT NULL,
    [OrderLineId]        INT              NOT NULL,
    [ProgramId]          INT              NOT NULL,
    [VoucherNumber]      VARCHAR (50)     NOT NULL,
    [ProductId]          INT              NOT NULL,
    [BeneficiaryInfoId]  BIGINT           NULL,
    [BalanceAvailable]   INT              NOT NULL,
    [Status]             INT              NOT NULL,
    [ExpiryDate]         DATETIME         NULL,
    [GUID]               UNIQUEIDENTIFIER NOT NULL,
    [ReservationBatchId] BIGINT           NULL,
    [CacheNode]          TINYINT          NULL,
    [ShortUrl]           VARCHAR (50)     NULL,
    [AuthCode]           VARCHAR (50)     NULL,
    [ExtendId]           BIGINT           NULL,
    [VSessionId]         VARCHAR (50)     NULL,
    [PinCode]            VARCHAR (100)    NULL
);


GO
CREATE NONCLUSTERED INDEX [Index_VoucherBuffer_Id]
    ON [dbo].[VoucherBuffer]([Id] ASC);


GO
CREATE NONCLUSTERED INDEX [Index_VoucherBuffer_OrderId]
    ON [dbo].[VoucherBuffer]([OrderId] ASC);


GO
CREATE NONCLUSTERED INDEX [Index_VoucherBuffer_OrderLineId]
    ON [dbo].[VoucherBuffer]([OrderLineId] ASC);

