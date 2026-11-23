CREATE TABLE [dbo].[InvoiceToBeRequested] (
    [Id]                 BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientQuotationId]  INT             NOT NULL,
    [OrderId]            INT             NULL,
    [Type]               TINYINT         NOT NULL,
    [TotalAmount]        NUMERIC (20, 6) DEFAULT ((0)) NOT NULL,
    [InvoiceRequestedId] BIGINT          NULL,
    [Status]             TINYINT         NOT NULL,
    [CreatedBy]          NVARCHAR (100)  NULL,
    [CreatedOn]          DATETIME        NOT NULL,
    CONSTRAINT [PK_InvoiceToBeRequested_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_InvoiceToBeRequested_ClientQuotation_ClientQuotationId] FOREIGN KEY ([ClientQuotationId]) REFERENCES [dbo].[ClientQuotation] ([Id]),
    CONSTRAINT [FK_InvoiceToBeRequested_InvoiceRequested_InvoiceRequestedId] FOREIGN KEY ([InvoiceRequestedId]) REFERENCES [dbo].[InvoiceRequested] ([Id]),
    CONSTRAINT [FK_InvoiceToBeRequested_Order_OrderId] FOREIGN KEY ([OrderId]) REFERENCES [dbo].[Order] ([Id])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1--Order
   2--Delivery Fee', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InvoiceToBeRequested', @level2type = N'COLUMN', @level2name = N'Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1--Created
   2--Cancelled', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InvoiceToBeRequested', @level2type = N'COLUMN', @level2name = N'Status';

