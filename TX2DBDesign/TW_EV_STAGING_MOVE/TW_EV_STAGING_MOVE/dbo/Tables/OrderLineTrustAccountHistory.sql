CREATE TABLE [dbo].[OrderLineTrustAccountHistory] (
    [Id]                      INT             IDENTITY (1, 1) NOT NULL,
    [OrderLineId]             INT             NOT NULL,
    [NeedTrustAccount]        BIT             NOT NULL,
    [CreateTime]              DATETIME        NOT NULL,
    [Creator]                 NVARCHAR (20)   NOT NULL,
    [OrderLineTrustAccountId] INT             NULL,
    [TrustAccountId]          INT             NULL,
    [TrustAccountOption]      INT             NULL,
    [TrustAccountBatchNo]     NVARCHAR (200)  NULL,
    [Amount]                  NUMERIC (20, 6) NULL,
    [ExpiryPolicyId]          INT             NULL,
    [ExpiryDate]              DATETIME        NULL,
    [ValidFrom]               DATETIME        NULL,
    [ValidTo]                 DATETIME        NULL
);


GO
CREATE NONCLUSTERED INDEX [IDX_OrderLineTrustAccountHistory_OrderLineId]
    ON [dbo].[OrderLineTrustAccountHistory]([OrderLineId] ASC);

