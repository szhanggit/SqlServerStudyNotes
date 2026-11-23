CREATE TABLE [dbo].[ClientQuotationProduct] (
    [Id]                    INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientQuotationId]     INT             NOT NULL,
    [ProductVersionId]      INT             NOT NULL,
    [ExpirySchemeId]        INT             NOT NULL,
    [MaxIssueVoucherNumber] INT             NULL,
    [CreatedBy]             NVARCHAR (50)   NOT NULL,
    [CreatedOn]             DATETIME        NOT NULL,
    [Status]                TINYINT         NOT NULL,
    [ApprovedBy]            NVARCHAR (50)   NULL,
    [ApprovedOn]            DATETIME        NULL,
    [SystemProcessFee]      NUMERIC (15, 4) DEFAULT ((0)) NOT NULL,
    [ExpirationDate]        DATETIME        NULL,
    [EnableCustomization]   BIT             NULL,
    [LastUpdateDate]        DATETIME        NULL,
    [UpdatedBy]             NVARCHAR (50)   NULL,
    CONSTRAINT [PK_CLIENTQUOTATIONPRODUCT] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ClientQuotationProduct_ClientQuotation_ClientQuotationId] FOREIGN KEY ([ClientQuotationId]) REFERENCES [dbo].[ClientQuotation] ([Id]),
    CONSTRAINT [FK_ClientQuotationProduct_ExpirationPolicy_ExpirySchemeId] FOREIGN KEY ([ExpirySchemeId]) REFERENCES [dbo].[ExpirationPolicy] ([Id]),
    CONSTRAINT [FK_ClientQuotationProduct_ProductVersion_ProductVersionId] FOREIGN KEY ([ProductVersionId]) REFERENCES [dbo].[ProductVersion] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IDX_ClientQuotationProduct_ClientQuotationId]
    ON [dbo].[ClientQuotationProduct]([ClientQuotationId] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IDX_ClientQuotationProduct_ProductVersionId]
    ON [dbo].[ClientQuotationProduct]([ProductVersionId] ASC) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1--Created
   16---Approved', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ClientQuotationProduct', @level2type = N'COLUMN', @level2name = N'Status';

