CREATE TABLE [dbo].[MediaLibrary_Backup] (
    [Id]                  INT            NOT NULL,
    [MediaCategory]       INT            NOT NULL,
    [FileName]            NVARCHAR (100) NULL,
    [Width]               INT            NOT NULL,
    [Height]              INT            NOT NULL,
    [Keyword]             NVARCHAR (120) NULL,
    [PhysicalFullPath]    NVARCHAR (500) NULL,
    [InternalURLSmall]    NVARCHAR (500) NULL,
    [InternalURLOriginal] NVARCHAR (500) NULL,
    [ExternalURL]         NVARCHAR (500) NULL,
    [Status]              TINYINT        NOT NULL,
    [LastUpdatedBy]       NVARCHAR (50)  NOT NULL,
    [LastUpdatedOn]       DATETIME       NOT NULL
);

