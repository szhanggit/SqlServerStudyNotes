CREATE TABLE [dbo].[Invoice_PriceMapping] (
    [PriceMapping_ID] NVARCHAR (100) CONSTRAINT [DF_Invoice_PriceMapping_PriceMapping_ID] DEFAULT (newid()) NOT NULL,
    [MerchantCode]    NVARCHAR (100) NOT NULL,
    [TXOrderId]       NVARCHAR (100) NOT NULL,
    [ProductCode]     NVARCHAR (100) NOT NULL,
    [ProductName]     NVARCHAR (100) NOT NULL,
    [InvoicePrice]    INT            NOT NULL,
    [Status]          NVARCHAR (1)   CONSTRAINT [DF_Invoice_PriceMapping_Status] DEFAULT ((0)) NOT NULL,
    [Updater]         NVARCHAR (50)  NULL,
    [UpdateDate]      DATETIME       NULL,
    [CreationDate]    DATETIME       CONSTRAINT [DF_Invoice_PriceMapping_CreationDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Invoice_PriceMapping] PRIMARY KEY CLUSTERED ([TXOrderId] ASC, [ProductCode] ASC) WITH (FILLFACTOR = 90)
);

