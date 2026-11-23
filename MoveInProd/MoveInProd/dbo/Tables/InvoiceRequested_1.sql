CREATE TABLE [dbo].[InvoiceRequested] (
    [Id]                BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientQuotationId] INT             NOT NULL,
    [TotalAmount]       NUMERIC (20, 6) DEFAULT ((0)) NOT NULL,
    [Status]            TINYINT         NOT NULL,
    [CreatedBy]         NVARCHAR (100)  NULL,
    [CreatedOn]         DATETIME        NOT NULL,
    CONSTRAINT [PK_InvoiceRequested_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_InvoiceRequested_ClientQuotation_ClientQuotationId] FOREIGN KEY ([ClientQuotationId]) REFERENCES [dbo].[ClientQuotation] ([Id])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1--Created
   2--Invoice Generated
   3--Cancelled', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InvoiceRequested', @level2type = N'COLUMN', @level2name = N'Status';

