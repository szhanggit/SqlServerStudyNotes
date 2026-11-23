CREATE TABLE [dbo].[Shop] (
    [Id]            INT            IDENTITY (1, 1) NOT NULL,
    [ProgramId]     INT            NULL,
    [ExternalId]    VARCHAR (50)   NULL,
    [IdentityCode]  VARCHAR (50)   NULL,
    [Name]          NVARCHAR (100) NULL,
    [MerchantId]    INT            NOT NULL,
    [TimeOffset]    VARCHAR (6)    NOT NULL,
    [Telephone]     VARCHAR (50)   NULL,
    [Address]       VARCHAR (600)  NULL,
    [Longitude]     FLOAT (53)     NULL,
    [Latitude]      FLOAT (53)     NULL,
    [SecurityKeyId] INT            NULL,
    [Status]        INT            NULL,
    [MaxFailNumber] INT            NOT NULL,
    [WorkKeyId]     INT            NULL,
    CONSTRAINT [PK_Shop_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Shop_Merchant_MerchantId] FOREIGN KEY ([MerchantId]) REFERENCES [dbo].[Merchant] ([Id]),
    CONSTRAINT [FK_Shop_Program_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[Program] ([Id]),
    CONSTRAINT [FK_Shop_SecurityKey_SecurityKeyId] FOREIGN KEY ([SecurityKeyId]) REFERENCES [dbo].[SecurityKey] ([Id]),
    CONSTRAINT [FK_Shop_WorkKey_WorkKeyId] FOREIGN KEY ([WorkKeyId]) REFERENCES [dbo].[WorkKey] ([Id]),
    CONSTRAINT [UK_Shop_ProgramId_ExternalId] UNIQUE NONCLUSTERED ([ProgramId] ASC, [ExternalId] ASC),
    CONSTRAINT [UK_Shop_ProgramId_IdentityCode] UNIQUE CLUSTERED ([ProgramId] ASC, [IdentityCode] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '0--Inactive
   1--Active', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Shop', @level2type = N'COLUMN', @level2name = N'Status';

