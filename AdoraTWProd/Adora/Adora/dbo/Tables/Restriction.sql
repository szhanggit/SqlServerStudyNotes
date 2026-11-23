CREATE TABLE [dbo].[Restriction] (
    [Id]                             INT          IDENTITY (1, 1) NOT NULL,
    [ProgramId]                      INT          NOT NULL,
    [ExternalId]                     VARCHAR (50) NOT NULL,
    [MaxTranNumber]                  INT          NULL,
    [MaxTranAmount]                  INT          NULL,
    [SingleMaxTranAmt]               INT          NULL,
    [PreAuthorizationExpiryInterval] INT          NOT NULL,
    [PreAuthorizationExpiryUnit]     TINYINT      NOT NULL,
    [ReverseLimitId]                 INT          NOT NULL,
    CONSTRAINT [PK_Restriction_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Restriction_MaxNumRestriction_MaxTranAmount] FOREIGN KEY ([MaxTranAmount]) REFERENCES [dbo].[MaxNumRestriction] ([Id]),
    CONSTRAINT [FK_Restriction_MaxNumRestriction_MaxTranNumber] FOREIGN KEY ([MaxTranNumber]) REFERENCES [dbo].[MaxNumRestriction] ([Id]),
    CONSTRAINT [FK_Restriction_Program_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[Program] ([Id]),
    CONSTRAINT [FK_Restriction_ReverseLimit_ReverseLimitId] FOREIGN KEY ([ReverseLimitId]) REFERENCES [dbo].[ReverseLimit] ([Id]),
    CONSTRAINT [UK_Restriction_ProgramId_ExternalId] UNIQUE CLUSTERED ([ProgramId] ASC, [ExternalId] ASC)
);

