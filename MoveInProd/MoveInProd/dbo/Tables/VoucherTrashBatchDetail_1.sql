CREATE TABLE [dbo].[VoucherTrashBatchDetail] (
    [Id]                  INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VoucherTrashBatchId] INT          NOT NULL,
    [VoucherId]           BIGINT       NOT NULL,
    [VoucherNumber]       VARCHAR (50) NOT NULL,
    [ExpiryDate]          DATETIME     NULL,
    CONSTRAINT [PK_VoucherTrashBatchDetail_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_VoucherTrashBatchDetail_VoucherTrashBatch_VoucherTrashBatchId] FOREIGN KEY ([VoucherTrashBatchId]) REFERENCES [dbo].[VoucherTrashBatch] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IDX_VoucherTrashBatchDetail_VoucherId]
    ON [dbo].[VoucherTrashBatchDetail]([VoucherId] ASC);

