CREATE TABLE [dbo].[VoucherTrustAccountBuffer] (
    [VoucherId]               BIGINT       NOT NULL,
    [OrderLineTrustAccountId] INT          NOT NULL,
    [SessionId]               VARCHAR (50) NULL,
    CONSTRAINT [PK_VoucherTrustAccountBuffer] PRIMARY KEY CLUSTERED ([VoucherId] ASC, [OrderLineTrustAccountId] ASC)
);

