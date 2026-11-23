CREATE TYPE [quotation].[tvp_QuoteProductComboAdd] AS TABLE (
    [ChildClientQuotationProductId] INT      NOT NULL,
    [ProductComboSetId]             INT      NOT NULL,
    [BusinessModelId]               INT      NOT NULL,
    [ExpirySchemeId]                INT      NOT NULL,
    [ExpirationDate]                DATETIME NULL,
    [Sequence]                      INT      NULL,
    [CustomizationProductId]        INT      NULL);

