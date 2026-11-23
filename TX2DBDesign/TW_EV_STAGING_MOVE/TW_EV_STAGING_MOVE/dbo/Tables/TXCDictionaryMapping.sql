CREATE TABLE [dbo].[TXCDictionaryMapping] (
    [DictionaryId] INT NOT NULL,
    [TXCTenantId]  INT NOT NULL,
    [ExternalId]   INT NULL,
    CONSTRAINT [PK_TXCDictionaryMapping] PRIMARY KEY CLUSTERED ([DictionaryId] ASC)
);

