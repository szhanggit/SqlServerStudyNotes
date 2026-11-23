CREATE TABLE [dbo].[EMV_ClientOrder] (
    [Id]                INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BatchId]           INT            NOT NULL,
    [ClientQuotationId] INT            NOT NULL,
    [ClientOrderNumber] NVARCHAR (100) NOT NULL,
    [Status]            TINYINT        NOT NULL,
    [CreatedTime]       DATETIME       NOT NULL,
    [UpdatedTime]       DATETIME       NOT NULL,
    CONSTRAINT [PK_EMV_ClientOrder] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_EMV_ClientOrder_Batch_Id] FOREIGN KEY ([BatchId]) REFERENCES [dbo].[EMV_Batch] ([Id]),
    CONSTRAINT [FK_EMV_ClientOrder_ClientQuotation_ClientQuotationId] FOREIGN KEY ([ClientQuotationId]) REFERENCES [dbo].[ClientQuotation] ([Id])
);

