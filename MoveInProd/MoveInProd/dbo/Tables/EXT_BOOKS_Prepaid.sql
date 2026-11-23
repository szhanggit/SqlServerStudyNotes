CREATE TABLE [dbo].[EXT_BOOKS_Prepaid] (
    [Id]             BIGINT   NOT NULL,
    [TrustStartDate] DATETIME NOT NULL,
    [TrustEndDate]   DATETIME NOT NULL,
    CONSTRAINT [PK_EXT_BOOKS_Prepaid_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

