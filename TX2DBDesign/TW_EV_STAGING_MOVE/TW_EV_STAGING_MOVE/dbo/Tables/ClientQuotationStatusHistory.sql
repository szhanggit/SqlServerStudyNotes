CREATE TABLE [dbo].[ClientQuotationStatusHistory] (
    [Id]                INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientQuotationId] INT            NOT NULL,
    [Operation]         TINYINT        NOT NULL,
    [Comment]           NVARCHAR (500) NULL,
    [Operator]          NVARCHAR (50)  NOT NULL,
    [OperationTime]     DATETIME       NOT NULL,
    CONSTRAINT [PK_CLIENTQUOTATIONSTATUSHISTOR] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ClientQuotationStatusHistory_ClientQuotation_ClientQuotationId] FOREIGN KEY ([ClientQuotationId]) REFERENCES [dbo].[ClientQuotation] ([Id])
);

