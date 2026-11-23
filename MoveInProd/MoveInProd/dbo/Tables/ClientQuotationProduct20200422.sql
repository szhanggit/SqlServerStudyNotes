CREATE TABLE [dbo].[ClientQuotationProduct20200422] (
    [Id]                    INT             IDENTITY (1, 1) NOT NULL,
    [ClientQuotationId]     INT             NOT NULL,
    [ProductVersionId]      INT             NOT NULL,
    [ExpirySchemeId]        INT             NOT NULL,
    [MaxIssueVoucherNumber] INT             NULL,
    [CreatedBy]             NVARCHAR (50)   NOT NULL,
    [CreatedOn]             DATETIME        NOT NULL,
    [Status]                TINYINT         NOT NULL,
    [ApprovedBy]            NVARCHAR (50)   NULL,
    [ApprovedOn]            DATETIME        NULL,
    [SystemProcessFee]      NUMERIC (15, 4) NOT NULL,
    [ExpirationDate]        DATETIME        NULL
);

