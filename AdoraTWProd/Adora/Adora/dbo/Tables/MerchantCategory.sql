CREATE TABLE [dbo].[MerchantCategory] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [ProgramId]    INT           NULL,
    [ExternalId]   VARCHAR (50)  NULL,
    [IdentityCode] VARCHAR (50)  NULL,
    [Name]         VARCHAR (100) NULL,
    [Status]       INT           NULL,
    CONSTRAINT [PK_MerchantCategory_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_MerchnatCategory_Program_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[Program] ([Id]),
    CONSTRAINT [UK_MerchantCategory_ProgramId_ExternalId] UNIQUE NONCLUSTERED ([ProgramId] ASC, [ExternalId] ASC),
    CONSTRAINT [UK_MerchantCategory_ProgramId_IdentityCode] UNIQUE NONCLUSTERED ([ProgramId] ASC, [IdentityCode] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '0--Inactive
   1--Active', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MerchantCategory', @level2type = N'COLUMN', @level2name = N'Status';

