CREATE TABLE [dbo].[VoucherOrder_20200120] (
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

