CREATE TABLE [dbo].[TXCClientMapping] (
    [ClientId]    INT NOT NULL,
    [TXCTenantId] INT NOT NULL,
    [ExternalId]  INT NULL,
    CONSTRAINT [PK_TXCClientMapping] PRIMARY KEY CLUSTERED ([ClientId] ASC)
);

