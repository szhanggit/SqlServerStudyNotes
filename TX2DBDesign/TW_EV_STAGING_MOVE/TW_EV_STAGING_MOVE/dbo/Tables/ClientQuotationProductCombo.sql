CREATE TABLE [dbo].[ClientQuotationProductCombo] (
    [Id]                            INT           IDENTITY (1, 1) NOT NULL,
    [ClientQuotationProductId]      INT           NOT NULL,
    [ProductComboSetId]             INT           NOT NULL,
    [BusinessModelId]               INT           NOT NULL,
    [ExpirySchemeId]                INT           NOT NULL,
    [ExpirationDate]                DATETIME      NULL,
    [ChildClientQuotationProductId] INT           NULL,
    [Sequence]                      INT           NULL,
    [CustomizationProductId]        INT           NULL,
    [LastUpdateDate]                DATETIME      NULL,
    [UpdatedBy]                     NVARCHAR (50) NULL,
    CONSTRAINT [PK_ClientQuotationProductCombo_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ClientQuotationProductCombo_BusinessModel_BusinessModelId] FOREIGN KEY ([BusinessModelId]) REFERENCES [dbo].[BusinessModel] ([Id]),
    CONSTRAINT [FK_ClientQuotationProductCombo_ClientQuotationProduct_ClientQuotationProductId] FOREIGN KEY ([ClientQuotationProductId]) REFERENCES [dbo].[ClientQuotationProduct] ([Id]),
    CONSTRAINT [FK_ClientQuotationProductCombo_ExpirationPolicy_ExpirySchemeId] FOREIGN KEY ([ExpirySchemeId]) REFERENCES [dbo].[ExpirationPolicy] ([Id]),
    CONSTRAINT [FK_ClientQuotationProductCombo_ProductComboSet_ProductComboSetId] FOREIGN KEY ([ProductComboSetId]) REFERENCES [dbo].[ProductComboSet] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IDX_ClientQuotationProductCombo_ClientQuotationProductId]
    ON [dbo].[ClientQuotationProductCombo]([ClientQuotationProductId] ASC);

