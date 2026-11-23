CREATE TABLE [dbo].[VoucherNumberAlgorithm] (
    [Id]             INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [NameId]         INT           NOT NULL,
    [ReflectionType] VARCHAR (100) NOT NULL,
    [DescriptionId]  INT           NULL,
    [SupportMode]    TINYINT       NOT NULL,
    CONSTRAINT [PK_VOUCHERNUMBERALGORITHM] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_VoucherNumberAlgorithm_Dictionary_DescriptionId] FOREIGN KEY ([DescriptionId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [FK_VoucherNumberAlgorithm_Dictionary_NameId] FOREIGN KEY ([NameId]) REFERENCES [dbo].[Dictionary] ([Id])
);

