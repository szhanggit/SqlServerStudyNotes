CREATE TABLE [dbo].[MerchantContract] (
    [Id]         INT          IDENTITY (1, 1) NOT NULL,
    [ProgramId]  INT          NOT NULL,
    [MerchantId] INT          NOT NULL,
    [ProductId]  INT          NOT NULL,
    [ExternalId] VARCHAR (50) NOT NULL,
    [StartDate]  INT          NOT NULL,
    [EndDate]    INT          NOT NULL,
    [Status]     INT          NOT NULL,
    CONSTRAINT [PK_MerchantContract_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC),
    CONSTRAINT [FK_MerchantContract_Merchant_MerchantId] FOREIGN KEY ([MerchantId]) REFERENCES [dbo].[Merchant] ([Id]),
    CONSTRAINT [FK_MerchantContract_Product_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([Id]),
    CONSTRAINT [FK_MerchantContract_Program_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[Program] ([Id]),
    CONSTRAINT [UK_MerchantContract_ProgramId_ExternalId] UNIQUE NONCLUSTERED ([ProgramId] ASC, [ExternalId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_MerchantContract_ProductId_Status]
    ON [dbo].[MerchantContract]([ProductId] ASC, [Status] ASC) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '0--Inactive
   1--Active', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MerchantContract', @level2type = N'COLUMN', @level2name = N'Status';

