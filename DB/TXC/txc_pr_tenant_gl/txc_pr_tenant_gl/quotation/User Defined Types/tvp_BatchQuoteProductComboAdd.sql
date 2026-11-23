CREATE TYPE [quotation].[tvp_BatchQuoteProductComboAdd] AS TABLE (
    [MasterProductCode]             NVARCHAR (250) NOT NULL,
    [ProductVersionId]              INT            NOT NULL,
    [ChildClientQuotationProductId] INT            NOT NULL,
    [ProductComboSetId]             INT            NOT NULL,
    [BusinessModelId]               INT            NOT NULL,
    [ExpirySchemeId]                INT            NOT NULL,
    [ExpirationDate]                DATETIME       NULL,
    [Sequence]                      INT            NULL,
    [CustomizationProductId]        INT            NULL);

