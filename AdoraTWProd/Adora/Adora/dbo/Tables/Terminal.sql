CREATE TABLE [dbo].[Terminal] (
    [Id]            INT          IDENTITY (1, 1) NOT NULL,
    [ProgramId]     INT          NULL,
    [ExternalId]    VARCHAR (50) NULL,
    [IdentityCode]  VARCHAR (50) NULL,
    [ShopId]        INT          NULL,
    [MerchantId]    INT          NULL,
    [TimeOffset]    VARCHAR (6)  NOT NULL,
    [SecurityKeyId] INT          NULL,
    [Status]        INT          NULL,
    [MaxFailNumber] INT          NOT NULL,
    [WorkKeyId]     INT          NULL,
    CONSTRAINT [PK_Terminal_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Terminal_Merchant_MerchantId] FOREIGN KEY ([MerchantId]) REFERENCES [dbo].[Merchant] ([Id]),
    CONSTRAINT [FK_Terminal_Program_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[Program] ([Id]),
    CONSTRAINT [FK_Terminal_SecurityKey_SecurityKeyId] FOREIGN KEY ([SecurityKeyId]) REFERENCES [dbo].[SecurityKey] ([Id]),
    CONSTRAINT [FK_Terminal_Shop_ShopId] FOREIGN KEY ([ShopId]) REFERENCES [dbo].[Shop] ([Id]),
    CONSTRAINT [FK_Terminal_WorkKey_WorkKeyId] FOREIGN KEY ([WorkKeyId]) REFERENCES [dbo].[WorkKey] ([Id]),
    CONSTRAINT [UK_Terminal_ProgramId_IdentityCode] UNIQUE CLUSTERED ([ProgramId] ASC, [ShopId] ASC, [IdentityCode] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '0--Inactive
   1--Active', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Terminal', @level2type = N'COLUMN', @level2name = N'Status';

