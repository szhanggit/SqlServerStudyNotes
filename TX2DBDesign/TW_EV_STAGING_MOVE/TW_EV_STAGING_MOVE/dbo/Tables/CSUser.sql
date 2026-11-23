CREATE TABLE [dbo].[CSUser] (
    [Id]              INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserName]        NVARCHAR (30)  NOT NULL,
    [Password]        VARCHAR (50)   NOT NULL,
    [RealName]        NVARCHAR (50)  NOT NULL,
    [Status]          TINYINT        NOT NULL,
    [Email]           NVARCHAR (100) NULL,
    [Mobile]          NVARCHAR (30)  NULL,
    [CreatedOn]       DATETIME       NOT NULL,
    [CreatedBy]       NVARCHAR (100) NOT NULL,
    [LastModifiedOn]  DATETIME       NOT NULL,
    [LastModifiedBy]  NVARCHAR (100) NOT NULL,
    [CSUserRole]      TINYINT        NOT NULL,
    [FactorAuth]      BIT            NULL,
    [FactorAuthEmail] VARCHAR (50)   NULL,
    CONSTRAINT [PK_CSUser] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UK_CSUser_UserName] UNIQUE NONCLUSTERED ([UserName] ASC)
);

