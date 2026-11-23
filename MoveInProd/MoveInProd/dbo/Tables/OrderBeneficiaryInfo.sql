CREATE TABLE [dbo].[OrderBeneficiaryInfo] (
    [Id]                BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
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
    [Status]            INT             CONSTRAINT [DF_BeneficiaryInfo_Status] DEFAULT ((0)) NOT NULL,
    [FaceValue]         INT             NULL,
    [FaceValueWithTax]  INT             NULL,
    [SoldPrice]         DECIMAL (15, 4) NULL,
    [SoldPriceWithTax]  DECIMAL (15, 4) NULL,
    CONSTRAINT [PK_ORDERBENEFICIARYINFO] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_OrderBeneficiaryInfo_Dictionary_LanguageId] FOREIGN KEY ([LanguageId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [FK_OrderBeneficiaryInfo_ExpirationPolicy_ExpirySchemeId] FOREIGN KEY ([ExpirySchemeId]) REFERENCES [dbo].[ExpirationPolicy] ([Id]),
    CONSTRAINT [FK_OrderBeneficiaryInfo_Member_MemberId] FOREIGN KEY ([MemberId]) REFERENCES [dbo].[Member] ([Id]),
    CONSTRAINT [FK_OrderBeneficiaryInfo_OrderLine_OrderLineId] FOREIGN KEY ([OrderLineId]) REFERENCES [dbo].[OrderLine] ([Id]),
    CONSTRAINT [FK_OrderBeneficiaryInfo_ProductVersion_ProductVersionId] FOREIGN KEY ([ProductVersionId]) REFERENCES [dbo].[ProductVersion] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IDX_OrderBeneficiaryInfo_Mobile]
    ON [dbo].[OrderBeneficiaryInfo]([Mobile] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_OrderBeneficiaryInfo_Email]
    ON [dbo].[OrderBeneficiaryInfo]([Email] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_OrderBeneficiaryInfo_ClientOrderNumber]
    ON [dbo].[OrderBeneficiaryInfo]([ClientOrderNumber] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_OrderBeneficiaryInfo_OrderLineId]
    ON [dbo].[OrderBeneficiaryInfo]([OrderLineId] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);

