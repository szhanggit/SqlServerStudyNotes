CREATE TABLE [dbo].[Voucher] (
    [Id]                       BIGINT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProgramId]                INT              NOT NULL,
    [VoucherNumber]            VARCHAR (50)     NOT NULL,
    [ProductId]                INT              NOT NULL,
    [BeneficiaryInfoId]        BIGINT           NULL,
    [BalanceAvailable]         INT              NOT NULL,
    [BalanceFrozen]            INT              DEFAULT ((0)) NOT NULL,
    [Status]                   INT              NOT NULL,
    [DistributionEmailStatus]  TINYINT          NULL,
    [EmailServiceProviderCode] VARCHAR (50)     NULL,
    [DistributionEmailMemo]    NVARCHAR (1000)  NULL,
    [DistributionSLMSStatus]   TINYINT          NULL,
    [SLMSServiceProviderCode]  VARCHAR (50)     NULL,
    [DistributionSLMSMemo]     NVARCHAR (1000)  NULL,
    [PublishedOn]              DATETIME         NULL,
    [ActivatedOn]              DATETIME         NULL,
    [ExpiryDate]               DATETIME         NULL,
    [Memo]                     NVARCHAR (1000)  NULL,
    [GUID]                     UNIQUEIDENTIFIER NOT NULL,
    [ReservationBatchId]       BIGINT           NOT NULL,
    [ConsumeTime]              DATETIME         NULL,
    [ConsumeMerchantCode]      VARCHAR (50)     NULL,
    [ConsumeShopCode]          VARCHAR (50)     NULL,
    [CacheNode]                TINYINT          NULL,
    [ConsumeTerminalSSN]       VARCHAR (50)     NULL,
    [LastTranOn]               DATETIME         NULL,
    [TrashReason]              NVARCHAR (1000)  NULL,
    [ShortUrl]                 VARCHAR (20)     COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
    [AuthCode]                 VARCHAR (20)     NULL,
    [ExtendId]                 BIGINT           NULL,
    [VSessionId]               VARCHAR (50)     NULL,
    [PinCode]                  VARCHAR (100)    NULL,
    CONSTRAINT [PK_VOUCHER] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_EdenredVoucher_OrderBeneficiaryInfo_BeneficiaryInfoId] FOREIGN KEY ([BeneficiaryInfoId]) REFERENCES [dbo].[OrderBeneficiaryInfo] ([Id]),
    CONSTRAINT [FK_Voucher_Product_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([Id]),
    CONSTRAINT [FK_Voucher_Program_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[Program] ([Id]),
    CONSTRAINT [FK_Voucher_VoucherReservationBatch_ReservationBatchId] FOREIGN KEY ([ReservationBatchId]) REFERENCES [dbo].[VoucherReservationBatch] ([Id]),
    CONSTRAINT [UK_Voucher_GUID] UNIQUE NONCLUSTERED ([GUID] ASC),
    CONSTRAINT [UK_Voucher_ProgramId_VoucherNumber] UNIQUE NONCLUSTERED ([ProgramId] ASC, [VoucherNumber] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_Voucher_Status]
    ON [dbo].[Voucher]([Status] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_Voucher_BeneficiaryInfoId]
    ON [dbo].[Voucher]([BeneficiaryInfoId] ASC)
    INCLUDE([VSessionId]);


GO
CREATE NONCLUSTERED INDEX [IDX_Voucher_ProductId_Status]
    ON [dbo].[Voucher]([ProductId] ASC, [Status] ASC) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = OFF);


GO
CREATE NONCLUSTERED INDEX [IX_Voucher_VoucherNumber]
    ON [dbo].[Voucher]([VoucherNumber] ASC)
    INCLUDE([PublishedOn]);


GO
CREATE NONCLUSTERED INDEX [IDX_Voucher_ShortUrl]
    ON [dbo].[Voucher]([ShortUrl] ASC) WITH (FILLFACTOR = 90);

