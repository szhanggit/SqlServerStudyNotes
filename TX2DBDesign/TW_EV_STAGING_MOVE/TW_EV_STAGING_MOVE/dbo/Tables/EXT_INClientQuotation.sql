CREATE TABLE [dbo].[EXT_INClientQuotation] (
    [Id]                INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientQuotationId] INT NOT NULL,
    [Days]              INT NULL,
    [Counts]            INT NULL,
    CONSTRAINT [PK_EXT_INClientQuotation] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_EXT_INClientQuotation_ClientQuotation_ClientQuotationId] FOREIGN KEY ([ClientQuotationId]) REFERENCES [dbo].[ClientQuotation] ([Id])
);

