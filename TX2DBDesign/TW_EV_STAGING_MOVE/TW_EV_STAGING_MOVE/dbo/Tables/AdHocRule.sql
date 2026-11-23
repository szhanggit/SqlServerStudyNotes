CREATE TABLE [dbo].[AdHocRule] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [RuleCode]           NVARCHAR (50)  NOT NULL,
    [RuleName]           NVARCHAR (200) NULL,
    [Description]        NVARCHAR (500) NULL,
    [SenderEmailAddress] NVARCHAR (100) NULL,
    [Status]             TINYINT        NOT NULL,
    [CreatedOn]          DATETIME       NOT NULL,
    [CreatedBy]          NVARCHAR (50)  NOT NULL,
    [LastModifiedOn]     DATETIME       NOT NULL,
    [LastModifiedBy]     NVARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_AdHocRule] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UK_AdHocRule] UNIQUE NONCLUSTERED ([RuleCode] ASC)
);

