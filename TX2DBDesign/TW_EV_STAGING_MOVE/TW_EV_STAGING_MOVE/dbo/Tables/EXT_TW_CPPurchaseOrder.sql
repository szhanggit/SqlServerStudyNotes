CREATE TABLE [dbo].[EXT_TW_CPPurchaseOrder] (
    [Id]                       INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [PONumber]                 VARCHAR (50)    NOT NULL,
    [ClientQuotationProductId] INT             NOT NULL,
    [TotalQuantity]            INT             NOT NULL,
    [AvailableQuantity]        INT             NOT NULL,
    [SoldPrice]                NUMERIC (15, 4) NOT NULL,
    [CreatedOn]                DATETIME        NOT NULL,
    CONSTRAINT [PK_EXT_TW_CPPurchaseOrder_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_EXT_TW_CPPurchaseOrder_ClientQuotationProduct_ClientQuotationProductId] FOREIGN KEY ([ClientQuotationProductId]) REFERENCES [dbo].[ClientQuotationProduct] ([Id])
);

