CREATE TABLE [dbo].[ApplyCondition_BusinessType] (
    [Id]               INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ApplyConditionId] INT            NOT NULL,
    [BusinessTypeId]   INT            NOT NULL,
    [CreatedBy]        NVARCHAR (100) NOT NULL,
    [CreatedOn]        DATETIME       NOT NULL,
    CONSTRAINT [PK_ApplyCondition_BusinessType_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ApplyCondition_BusinessType_ApplyCondition_ApplyConditionId] FOREIGN KEY ([ApplyConditionId]) REFERENCES [dbo].[ApplyCondition] ([Id])
);

