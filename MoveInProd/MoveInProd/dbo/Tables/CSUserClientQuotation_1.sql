CREATE TABLE [dbo].[CSUserClientQuotation] (
    [Id]          INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CSUserId]    INT      NOT NULL,
    [QuotationId] INT      NOT NULL,
    [CreatedOn]   DATETIME NOT NULL,
    CONSTRAINT [PK_CSUserClientQuotation_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_CSUserClientQuotation_CSUser_CSUserId] FOREIGN KEY ([CSUserId]) REFERENCES [dbo].[CSUser] ([Id]),
    CONSTRAINT [FK_CSUserClientQuotation_Quotation_QuotationId] FOREIGN KEY ([QuotationId]) REFERENCES [dbo].[ClientQuotation] ([Id])
);

