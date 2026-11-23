CREATE TABLE [dbo].[VoucherSupplierSyncOrderBuffer_TX2] (
    [OrderId]                 INT           NOT NULL,
    [ProductCode]             VARCHAR (50)  NOT NULL,
    [Mobile]                  VARCHAR (50)  NULL,
    [Email]                   VARCHAR (100) NULL,
    [ThirdPartyVoucherNumber] VARCHAR (50)  NOT NULL,
    CONSTRAINT [UK_ProductCode_ThirdPartyVoucherNumber] UNIQUE NONCLUSTERED ([ProductCode] ASC, [ThirdPartyVoucherNumber] ASC)
);

