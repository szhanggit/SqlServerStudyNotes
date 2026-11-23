CREATE TABLE [dbo].[VoucherOrder] (
    [OrderId]                INT      NOT NULL,
    [OrderLineId]            INT      NOT NULL,
    [OrderBeneficiaryInfoId] BIGINT   NOT NULL,
    [OrderSN]                INT      NOT NULL,
    [OrderLineSN]            INT      NOT NULL,
    [OrderBeneficiaryInfoSN] INT      NOT NULL,
    [VoucherId]              BIGINT   NULL,
    [AdoraTaskId]            BIGINT   NULL,
    [IsEmailDelivery]        BIT      NULL,
    [IsSLMSDelivery]         BIT      NULL,
    [EmailTaskId]            BIGINT   NULL,
    [SLMSTaskId]             BIGINT   NULL,
    [CreationTime]           DATETIME NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IDX_VoucherOrder_OrderId]
    ON [dbo].[VoucherOrder]([OrderId] ASC, [OrderSN] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_VoucherOrder_OrderLineId]
    ON [dbo].[VoucherOrder]([OrderLineId] ASC, [OrderLineSN] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_VoucherOrder_OrderBeneficiaryInfoId]
    ON [dbo].[VoucherOrder]([OrderBeneficiaryInfoId] ASC, [OrderBeneficiaryInfoSN] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_VoucherOrder_VoucherId]
    ON [dbo].[VoucherOrder]([VoucherId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_VoucherOrder_AdoraTaskId]
    ON [dbo].[VoucherOrder]([AdoraTaskId] ASC);

