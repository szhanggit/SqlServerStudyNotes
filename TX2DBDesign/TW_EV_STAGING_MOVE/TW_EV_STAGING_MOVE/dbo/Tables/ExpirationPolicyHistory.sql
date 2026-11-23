CREATE TABLE [dbo].[ExpirationPolicyHistory] (
    [Id]                            INT           IDENTITY (1, 1) NOT NULL,
    [ClientQuotationProductId]      INT           NOT NULL,
    [ClientQuotationProductComboId] INT           NULL,
    [VersionNo]                     TINYINT       NOT NULL,
    [ExpirySchemeId]                INT           NOT NULL,
    [ExpirationDate]                DATETIME      NULL,
    [CreatedTime]                   DATETIME      NOT NULL,
    [CreatedBy]                     NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_ExpirationPolicyHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
);

