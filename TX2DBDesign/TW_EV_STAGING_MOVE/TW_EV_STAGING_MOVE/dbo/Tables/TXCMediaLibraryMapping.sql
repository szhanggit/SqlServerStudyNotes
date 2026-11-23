CREATE TABLE [dbo].[TXCMediaLibraryMapping] (
    [MediaLibraryId] INT NOT NULL,
    [TXCTenantId]    INT NOT NULL,
    [ExternalId]     INT NULL,
    CONSTRAINT [PK_TXCMediaLibraryMapping] PRIMARY KEY CLUSTERED ([MediaLibraryId] ASC)
);

