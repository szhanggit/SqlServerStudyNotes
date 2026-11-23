CREATE TABLE [dbo].[Merchant] (
    [Id]                       INT            IDENTITY (1, 1) NOT NULL,
    [ProgramId]                INT            NOT NULL,
    [ExternalId]               VARCHAR (50)   NULL,
    [IdentityCode]             VARCHAR (50)   NULL,
    [Name]                     NVARCHAR (500) NULL,
    [TimeOffset]               VARCHAR (6)    NOT NULL,
    [Status]                   INT            NULL,
    [CategoryId]               INT            NULL,
    [SecurityKeyId]            INT            NULL,
    [MaxFailNumber]            INT            NOT NULL,
    [WorkKeyId]                INT            NULL,
    [NotificationMerchantCode] VARCHAR (50)   NULL,
    [TPCClientId]              VARCHAR (200)  NULL,
    [TPCClientSecret]          VARCHAR (200)  NULL,
    CONSTRAINT [PK_Merchant_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Merchant_MerchantCategory_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[MerchantCategory] ([Id]),
    CONSTRAINT [FK_Merchant_Program_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[Program] ([Id]),
    CONSTRAINT [FK_Merchant_SecurityKey_SecurityKeyId] FOREIGN KEY ([SecurityKeyId]) REFERENCES [dbo].[SecurityKey] ([Id]),
    CONSTRAINT [FK_Merchant_WorkKey_WorkKeyId] FOREIGN KEY ([WorkKeyId]) REFERENCES [dbo].[WorkKey] ([Id]),
    CONSTRAINT [UK_Merchant_ProgramId_ExternalId] UNIQUE NONCLUSTERED ([ProgramId] ASC, [ExternalId] ASC),
    CONSTRAINT [UK_Merchant_ProgramId_IdentityCode] UNIQUE NONCLUSTERED ([ProgramId] ASC, [IdentityCode] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Merchant_ID_IdentityCode]
    ON [dbo].[Merchant]([Id] ASC, [IdentityCode] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '0--Inactive
   1--Active', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Merchant', @level2type = N'COLUMN', @level2name = N'Status';

