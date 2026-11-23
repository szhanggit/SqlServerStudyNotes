CREATE TYPE [dbo].[VoucherBannerImageInfoType] AS TABLE (
    [Identitykey]                 VARCHAR (100) NULL,
    [ProductId]                   INT           NULL,
    [OrderLineId]                 INT           NULL,
    [LanguageId]                  INT           NULL,
    [ContentTagId]                INT           NULL,
    [IsDynamic]                   BIT           NULL,
    [EmailTemplateVersionId]      INT           NULL,
    [OrderEmailTemplateVersionId] INT           NULL);

