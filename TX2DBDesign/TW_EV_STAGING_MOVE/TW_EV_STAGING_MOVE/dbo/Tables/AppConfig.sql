CREATE TABLE [dbo].[AppConfig] (
    [Id]          INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Key]         VARCHAR (200)  NOT NULL,
    [Value]       NVARCHAR (500) NOT NULL,
    [Comment]     NVARCHAR (500) NULL,
    [Environment] VARCHAR (50)   NULL,
    [UpdatedOn]   DATETIME       NOT NULL,
    CONSTRAINT [PK_AppConfig_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

