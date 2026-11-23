CREATE TABLE [dbo].[VoucherOrderBuffer] (
    [OrderId]                INT          NOT NULL,
    [OrderLineId]            INT          NOT NULL,
    [OrderBeneficiaryInfoId] BIGINT       NOT NULL,
    [VoucherQuantity]        INT          NOT NULL,
    [OrderSN]                INT          NOT NULL,
    [OrderLineSN]            INT          NOT NULL,
    [OrderBeneficiaryInfoSN] INT          NOT NULL,
    [VoucherId]              BIGINT       NULL,
    [VoucherNumber]          VARCHAR (50) NULL,
    [AdoraTaskId]            BIGINT       NULL,
    [IsEmailDelivery]        BIT          NULL,
    [IsSLMSDelivery]         BIT          NULL,
    [CreationTime]           DATETIME     NOT NULL,
    [SessionId]              VARCHAR (50) NULL
);


GO
CREATE NONCLUSTERED INDEX [Index_VoucherOrderBuffer_OrderId]
    ON [dbo].[VoucherOrderBuffer]([OrderId] ASC);


GO
CREATE NONCLUSTERED INDEX [Index_VoucherOrderBuffer_OrderLineId]
    ON [dbo].[VoucherOrderBuffer]([OrderLineId] ASC);

