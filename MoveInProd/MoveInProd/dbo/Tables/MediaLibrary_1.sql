CREATE TABLE [dbo].[MediaLibrary] (
    [Id]                  INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MediaCategory]       INT            NOT NULL,
    [FileName]            NVARCHAR (100) NULL,
    [Width]               INT            NOT NULL,
    [Height]              INT            NOT NULL,
    [Keyword]             NVARCHAR (50)  NULL,
    [PhysicalFullPath]    NVARCHAR (500) NULL,
    [InternalURLSmall]    NVARCHAR (500) NULL,
    [InternalURLOriginal] NVARCHAR (500) NULL,
    [ExternalURL]         NVARCHAR (500) NULL,
    [Status]              TINYINT        NOT NULL,
    [LastUpdatedBy]       NVARCHAR (50)  NOT NULL,
    [LastUpdatedOn]       DATETIME       NOT NULL,
    CONSTRAINT [PK_MEDIALIBRARY] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1--Active
   2--Inactive', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MediaLibrary', @level2type = N'COLUMN', @level2name = N'Status';

