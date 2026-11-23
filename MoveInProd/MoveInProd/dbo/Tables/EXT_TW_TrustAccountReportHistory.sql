CREATE TABLE [dbo].[EXT_TW_TrustAccountReportHistory] (
    [Id]                  BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
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
    [ReportBatchNo]       VARCHAR (20)   NOT NULL,
    [CreatedOn]           DATETIME       NOT NULL,
    CONSTRAINT [PK_EXT_TW_TrustAccountReportHistory_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

