CREATE TABLE [dbo].[Invoice] (
    [Id]                 BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [InvoiceNumber]      NVARCHAR (100)  NOT NULL,
    [InvoiceDate]        DATE            NOT NULL,
    [TotalAmount]        NUMERIC (20, 6) DEFAULT ((0)) NOT NULL,
    [InvoiceRequestedId] BIGINT          NOT NULL,
    [Note]               NVARCHAR (1000) NULL,
    [Status]             TINYINT         NOT NULL,
    [CreatedBy]          NVARCHAR (100)  NULL,
    [CreatedOn]          DATETIME        NOT NULL,
    CONSTRAINT [PK_Invoice_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Invoice_InvoiceRequested_InvoiceRequestedId] FOREIGN KEY ([InvoiceRequestedId]) REFERENCES [dbo].[InvoiceRequested] ([Id])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1--Created
   2--Cancelled', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Invoice', @level2type = N'COLUMN', @level2name = N'Status';

