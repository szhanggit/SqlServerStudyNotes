CREATE TABLE [dbo].[UserBasicInfo] (
    [Id]             INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserType]       TINYINT        NOT NULL,
    [UserName]       NVARCHAR (30)  NOT NULL,
    [Password]       VARCHAR (50)   NOT NULL,
    [RealName]       NVARCHAR (50)  NOT NULL,
    [Status]         TINYINT        NOT NULL,
    [Email]          NVARCHAR (100) NULL,
    [Mobile]         NVARCHAR (30)  NULL,
    [CreatedOn]      DATETIME       NOT NULL,
    [CreatedBy]      NVARCHAR (100) NOT NULL,
    [LastModifiedOn] DATETIME       NOT NULL,
    [LastModifiedBy] NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_UserBasicInfo] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [UK_UserBasicInfo_UserName_UserType] UNIQUE NONCLUSTERED ([UserName] ASC, [UserType] ASC) WITH (FILLFACTOR = 90)
);

