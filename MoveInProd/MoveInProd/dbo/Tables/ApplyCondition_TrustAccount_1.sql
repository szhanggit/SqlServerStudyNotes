CREATE TABLE [dbo].[ApplyCondition_TrustAccount] (
    [Id]               INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ApplyConditionId] INT            NOT NULL,
    [TrustAccountId]   INT            NOT NULL,
    [CreatedBy]        NVARCHAR (100) NOT NULL,
    [CreatedOn]        DATETIME       NOT NULL,
    CONSTRAINT [PK_ApplyCondition_TrustAccount] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ApplyCondition_TrustAccount_ApplyCondition_ApplyConditionId] FOREIGN KEY ([ApplyConditionId]) REFERENCES [dbo].[ApplyCondition] ([Id])
);

