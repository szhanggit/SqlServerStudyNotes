CREATE TABLE [dbo].[OrderLineTrustAccount] (
    [Id]                  INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OrderLineId]         INT             NOT NULL,
    [TrustAccountId]      INT             NOT NULL,
    [TrustAccountOption]  INT             NOT NULL,
    [TrustAccountBatchNo] NVARCHAR (200)  NULL,
    [Amount]              NUMERIC (20, 6) NULL,
    [ExpiryPolicyId]      INT             NOT NULL,
    [ExpiryDate]          DATETIME        NULL,
    [ValidFrom]           DATETIME        NOT NULL,
    [ValidTo]             DATETIME        NOT NULL,
    CONSTRAINT [PK_OrderLineTrustAccount_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_OrderLineTrustAccount_OrderLine_OrderLineId] FOREIGN KEY ([OrderLineId]) REFERENCES [dbo].[OrderLine] ([Id]),
    CONSTRAINT [FK_OrderLineTrustAccount_TrustAccount_TrustAccountId] FOREIGN KEY ([TrustAccountId]) REFERENCES [dbo].[TrustAccount] ([Id]),
    CONSTRAINT [FK_OrderLineTrustAccount_TrustExpiryPolicy_ExpiryPolicyId] FOREIGN KEY ([ExpiryPolicyId]) REFERENCES [dbo].[TrustExpiryPolicy] ([Id])
);

