CREATE TYPE [quotation].[tvp_BatchQuoteProductAdd] AS TABLE (
    [ProductCode]           NVARCHAR (250)  NOT NULL,
    [ProductVersionId]      INT             NOT NULL,
    [ExpirySchemeId]        INT             NOT NULL,
    [MaxIssueVoucherNumber] INT             NULL,
    [SystemProcessFee]      NUMERIC (15, 4) NOT NULL,
    [ExpirationDate]        DATETIME        NULL,
    [EnableCustomization]   BIT             NULL,
    [Status]                INT             NOT NULL);

