CREATE TABLE [dbo].[VoucherOrderBufferHistory] (
    [OrderId]                INT          NOT NULL,
    [OrderLineId]            INT          NOT NULL,
    [OrderBeneficiaryInfoId] BIGINT       NOT NULL,
    [OrderSN]                INT          NOT NULL,
    [OrderLineSN]            INT          NOT NULL,
    [OrderBeneficiaryInfoSN] INT          NOT NULL,
    [VoucherNumber]          VARCHAR (50) NOT NULL,
    [AdoraTaskId]            BIGINT       NULL,
    [CreationTime]           DATETIME     NOT NULL,
    [SessionId]              VARCHAR (50) NULL
);


GO
CREATE NONCLUSTERED INDEX [Index_VoucherOrderBufferHistory_OrderId]
    ON [dbo].[VoucherOrderBufferHistory]([OrderId] ASC);

