CREATE TABLE [dbo].[TXCAddressMapping] (
    [AddressId]   INT NOT NULL,
    [TXCTenantId] INT NOT NULL,
    [ExternalId]  INT NULL,
    CONSTRAINT [PK_TXCAddressMapping] PRIMARY KEY CLUSTERED ([AddressId] ASC)
);

