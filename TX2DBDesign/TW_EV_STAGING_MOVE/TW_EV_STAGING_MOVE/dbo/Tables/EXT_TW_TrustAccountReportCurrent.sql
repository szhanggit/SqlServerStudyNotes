CREATE TABLE [dbo].[EXT_TW_TrustAccountReportCurrent] (
    [ReportType]          TINYINT        NOT NULL,
    [OrderLineId]         INT            NOT NULL,
    [PublishedOn]         DATETIME       NOT NULL,
    [ProductName]         NVARCHAR (200) NOT NULL,
    [Brand]               NVARCHAR (200) NOT NULL,
    [ProgramId]           INT            NOT NULL,
    [VoucherNumber]       VARCHAR (50)   NOT NULL,
    [VoucherStatus]       INT            NOT NULL,
    [LastTranOn]          DATETIME       NULL,
    [ConsumeTime]         DATETIME       NULL,
    [ConsumeMerchantCode] VARCHAR (50)   NULL,
    [ConsumeShopCode]     VARCHAR (50)   NULL,
    [ReportDate]          INT            NOT NULL,
    [ReportBatchNo]       VARCHAR (20)   NOT NULL
);

