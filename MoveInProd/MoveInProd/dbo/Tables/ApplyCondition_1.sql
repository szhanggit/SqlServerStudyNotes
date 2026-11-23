CREATE TABLE [dbo].[ApplyCondition] (
    [Id]        INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]      NVARCHAR (255) NOT NULL,
    [Condition] NVARCHAR (MAX) NULL,
    [CreatedBy] NVARCHAR (100) NOT NULL,
    [CreatedOn] DATETIME       NOT NULL,
    CONSTRAINT [PK_ApplyCondition_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

