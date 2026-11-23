CREATE TABLE [dbo].[EXT_TW_OrderLineTrustAccount] (
    [Id]                  INT             NOT NULL,
    [TrustAccount]        NVARCHAR (200)  NOT NULL,
    [TrustAccountBank]    NVARCHAR (200)  NOT NULL,
    [TrustAccountFee]     NUMERIC (20, 6) NOT NULL,
    [TrustAccountBatchNo] NVARCHAR (200)  NOT NULL,
    [TrustAccountAmount]  NUMERIC (20, 6) NOT NULL,
    [ReportStartTime]     DATETIME        NULL,
    CONSTRAINT [PK_EXT_TW_OrderLineTrustAccount_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

