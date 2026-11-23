CREATE TABLE [dbo].[Order] (
    [Id]                             INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientQuotationId]              INT             NOT NULL,
    [OrderNumber]                    VARCHAR (50)    NOT NULL,
    [Mode]                           TINYINT         NOT NULL,
    [IsDirectDelivery]               BIT             NOT NULL,
    [PublishDatetime]                DATETIME        NOT NULL,
    [Status]                         INT             NOT NULL,
    [ExecutingStatus]                TINYINT         NULL,
    [ExecutingResponse]              NVARCHAR (50)   NULL,
    [CreatedBy]                      NVARCHAR (50)   NOT NULL,
    [CreatedOn]                      DATETIME        NOT NULL,
    [PackageReceiver]                VARCHAR (100)   NULL,
    [PackagePassword]                VARCHAR (20)    NULL,
    [OrderName]                      NVARCHAR (200)  NOT NULL,
    [ShortUrlAuthCodeGenerationWay]  TINYINT         NOT NULL,
    [OrderGroupId]                   INT             NULL,
    [IndirectFileFormat]             TINYINT         NULL,
    [MWVEmailTemplate]               TINYINT         NOT NULL,
    [ExportBarcodeInfo]              TINYINT         NULL,
    [VoucherSupplierId]              INT             NULL,
    [VoucherSupplierOrderNumber]     VARCHAR (50)    NULL,
    [VoucherSupplierQuotationNumber] VARCHAR (50)    NULL,
    [PackagePinReceiver]             VARCHAR (100)   NULL,
    [EmailAttachShortURLImage]       TINYINT         NULL,
    [UrlType]                        INT             CONSTRAINT [DF_ORDER_UrlType] DEFAULT ((0)) NOT NULL,
    [GenerateSequenceNumber]         BIT             NULL,
    [Memo]                           NVARCHAR (2000) NULL,
    [NeededPreIssue]                 BIT             DEFAULT ((0)) NULL,
    [WalletSLMSTemplateVersionId]    INT             NULL,
    CONSTRAINT [PK_Order_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    FOREIGN KEY ([WalletSLMSTemplateVersionId]) REFERENCES [dbo].[SLMSTemplateVersion] ([Id]),
    CONSTRAINT [FK_Order_ClientQuotation_ClientQuotationId] FOREIGN KEY ([ClientQuotationId]) REFERENCES [dbo].[ClientQuotation] ([Id]),
    CONSTRAINT [FK_Order_OrderGroup_OrderGroupId] FOREIGN KEY ([OrderGroupId]) REFERENCES [dbo].[OrderGroup] ([Id]),
    CONSTRAINT [FK_Order_VoucherSupplier_VoucherSupplierId] FOREIGN KEY ([VoucherSupplierId]) REFERENCES [dbo].[VoucherSupplier] ([Id]),
    CONSTRAINT [UK_Order_OrderNumber] UNIQUE NONCLUSTERED ([OrderNumber] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1---Fixed
   2---Open', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'Mode';

