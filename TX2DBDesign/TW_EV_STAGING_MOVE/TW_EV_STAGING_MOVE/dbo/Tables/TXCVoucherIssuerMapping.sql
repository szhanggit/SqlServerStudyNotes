CREATE TABLE [dbo].[TXCVoucherIssuerMapping] (
    [VoucherIssuerId] INT NOT NULL,
    [TXCTenantId]     INT NOT NULL,
    [ExternalId]      INT NULL,
    CONSTRAINT [PK_TXCVoucherIssuerMapping] PRIMARY KEY CLUSTERED ([VoucherIssuerId] ASC)
);

