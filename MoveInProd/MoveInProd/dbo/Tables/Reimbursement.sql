CREATE TABLE [dbo].[Reimbursement] (
    [Id]                          BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [StartDate]                   INT             NOT NULL,
    [EndDate]                     INT             NOT NULL,
    [MerchantId]                  INT             NOT NULL,
    [ReimbursementAmount]         NUMERIC (20, 6) DEFAULT ((0)) NOT NULL,
    [PONumber]                    NVARCHAR (50)   NULL,
    [Status]                      TINYINT         NOT NULL,
    [CreatedOn]                   DATETIME        NOT NULL,
    [PaidOn]                      DATETIME        NULL,
    [ConfirmedOn]                 DATETIME        NULL,
    [CancelledOn]                 DATETIME        NULL,
    [Title]                       NVARCHAR (100)  NOT NULL,
    [InvoiceNumber]               NVARCHAR (100)  NULL,
    [InvoiceDate]                 DATE            NULL,
    [InvoiceAmount]               NUMERIC (20, 6) NULL,
    [InvoiceTax]                  NUMERIC (20, 6) NULL,
    [Memo]                        NVARCHAR (1000) NULL,
    [ReimbursementDetailFilePath] NVARCHAR (500)  NULL,
    [NotificationId]              BIGINT          NULL,
    [CreationWay]                 TINYINT         NOT NULL,
    CONSTRAINT [PK_Reimbursement_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Reimbursement_Merchant_MerchantId] FOREIGN KEY ([MerchantId]) REFERENCES [dbo].[Merchant] ([Id]),
    CONSTRAINT [FK_Reimbursement_ReimbursementNotification_NotificationId] FOREIGN KEY ([NotificationId]) REFERENCES [dbo].[ReimbursementNotification] ([Id])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1--Created
   2--Paid
   3--Cancelled', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Reimbursement', @level2type = N'COLUMN', @level2name = N'Status';

