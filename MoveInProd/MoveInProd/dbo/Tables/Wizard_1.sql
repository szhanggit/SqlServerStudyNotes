CREATE TABLE [dbo].[Wizard] (
    [Id]                BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [WizardType]        TINYINT        NOT NULL,
    [WizardKey]         NVARCHAR (200) NOT NULL,
    [StepNumber]        TINYINT        NOT NULL,
    [SerializedContent] NVARCHAR (MAX) NOT NULL,
    [Modifier]          NVARCHAR (50)  NOT NULL,
    [LastModifyTime]    DATETIME       NOT NULL,
    CONSTRAINT [PK_WIZARD] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1--product', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Wizard', @level2type = N'COLUMN', @level2name = N'WizardType';

