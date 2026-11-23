CREATE TABLE [dbo].[EXT_TW_TrustAccountReport] (
    [Id]                  BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ReportType]          TINYINT         NOT NULL,
    [OrderLineId]         INT             NOT NULL,
    [PublishedOn]         DATETIME        NOT NULL,
    [Brand]               NVARCHAR (200)  NOT NULL,
    [TrustAccountBatchNo] NVARCHAR (200)  NOT NULL,
    [TrustAccountBank]    NVARCHAR (200)  NOT NULL,
    [GuaranteedStartDate] INT             NOT NULL,
    [GuaranteedEndDate]   INT             NOT NULL,
    [IssuedQuantity]      INT             NOT NULL,
    [UsedQuantity]        INT             NOT NULL,
    [TrashedQuantity]     INT             NOT NULL,
    [ActiveQuantity]      INT             NOT NULL,
    [TrustAccountAmount]  NUMERIC (20, 6) NOT NULL,
    [BankCommission]      NUMERIC (20, 6) NOT NULL,
    [GuaranteedAmount]    NUMERIC (20, 6) NOT NULL,
    [ReportDate]          INT             NOT NULL,
    [ReportBatchNo]       VARCHAR (20)    NOT NULL,
    [CreatedOn]           DATETIME        NOT NULL,
    CONSTRAINT [PK_EXT_TW_TrustAccountReport_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

