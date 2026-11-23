CREATE TABLE [dbo].[ClientGroup] (
    [Id]        INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [GroupName] NVARCHAR (50) NOT NULL,
    [Status]    TINYINT       NOT NULL,
    CONSTRAINT [PK_ClientGroup] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0--inactive
   1--active', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ClientGroup', @level2type = N'COLUMN', @level2name = N'Status';

