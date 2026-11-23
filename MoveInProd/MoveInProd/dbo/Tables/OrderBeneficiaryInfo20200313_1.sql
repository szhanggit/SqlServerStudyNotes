CREATE TABLE [dbo].[OrderBeneficiaryInfo20200313] (
    [Id]                BIGINT          IDENTITY (1, 1) NOT NULL,
    [OrderLineId]       INT             NOT NULL,
    [Mobile]            VARCHAR (50)    NULL,
    [Email]             VARCHAR (100)   NULL,
    [VoucherQuantity]   INT             NOT NULL,
    [ActiveDate]        DATETIME        NULL,
    [ExpirySchemeId]    INT             NOT NULL,
    [ExpiryDate]        DATETIME        NULL,
    [ClientOrderNumber] VARCHAR (50)    NULL,
    [Memo]              NVARCHAR (1000) NULL,
    [ProductVersionId]  INT             NULL,
    [Name]              NVARCHAR (100)  NULL,
    [Address]           NVARCHAR (200)  NULL,
    [PostCode]          VARCHAR (20)    NULL,
    [EDOrderNumber]     VARCHAR (50)    NULL,
    [MemberId]          INT             NULL,
    [LanguageId]        INT             NULL,
    [Status]            INT             NOT NULL
);

