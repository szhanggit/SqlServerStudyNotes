CREATE TYPE [dbo].[EMV_VoucherStockUploadRow] AS TABLE (
    [Denomination] INT              NOT NULL,
    [SKU]          VARCHAR (25)     NOT NULL,
    [VoucherCode]  VARCHAR (50)     NOT NULL,
    [IssueDate]    DATETIME         NOT NULL,
    [ExpiryDate]   DATETIME         NOT NULL,
    [GUID]         UNIQUEIDENTIFIER NOT NULL,
    [GCID]         VARCHAR (50)     NOT NULL,
    [PODate]       VARCHAR (200)    NOT NULL,
    [PONumber]     VARCHAR (200)    NOT NULL,
    [PIN]          VARCHAR (100)    NULL);

