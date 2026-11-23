CREATE TABLE [dbo].[ClientQuotationServiceFee] (
    [Id]                INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientQuotationId] INT             NOT NULL,
    [ServiceFeeId]      INT             NOT NULL,
    [SoldPrice]         NUMERIC (15, 4) DEFAULT ((0)) NOT NULL,
    [Quantity]          INT             NOT NULL,
    CONSTRAINT [PK_ClientQuotationServiceFee_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ClientQuotationServiceFee_ClientQuotation_ClientQuotationId] FOREIGN KEY ([ClientQuotationId]) REFERENCES [dbo].[ClientQuotation] ([Id]),
    CONSTRAINT [FK_ClientQuotationServiceFee_ServiceFee_ServiceFeeId] FOREIGN KEY ([ServiceFeeId]) REFERENCES [dbo].[ServiceFee] ([Id])
);

