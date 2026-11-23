CREATE TABLE [dbo].[VoucherTrustAccount] (
    [Id]                  BIGINT          NOT NULL,
    [TrustAccountId]      INT             NOT NULL,
    [TrustAmountOption]   INT             NOT NULL,
    [TrustAccountBatchNo] NVARCHAR (200)  NULL,
    [Amount]              NUMERIC (20, 6) NULL,
    [ExpiryPolicyId]      INT             NOT NULL,
    [ExpiryDate]          DATETIME        NULL,
    CONSTRAINT [PK_VoucherTrustAccount] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_VoucherTrustAccount_TrustExpiryPolicy_ExpiryPolicyId] FOREIGN KEY ([ExpiryPolicyId]) REFERENCES [dbo].[TrustExpiryPolicy] ([Id]),
    CONSTRAINT [FK_VoucherTrustAccount_Voucher_Id] FOREIGN KEY ([Id]) REFERENCES [dbo].[Voucher] ([Id])
);

