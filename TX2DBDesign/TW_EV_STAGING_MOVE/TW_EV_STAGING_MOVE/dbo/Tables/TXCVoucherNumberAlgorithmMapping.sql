CREATE TABLE [dbo].[TXCVoucherNumberAlgorithmMapping] (
    [Id]                          INT IDENTITY (1, 1) NOT NULL,
    [TX2VoucherNumberAlgorithmId] INT NOT NULL,
    [TXCVoucherNumberAlgorithmId] INT NOT NULL,
    [TenantId]                    INT NOT NULL,
    CONSTRAINT [PK_TXCVoucherNumberAlgorithmMapping] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

