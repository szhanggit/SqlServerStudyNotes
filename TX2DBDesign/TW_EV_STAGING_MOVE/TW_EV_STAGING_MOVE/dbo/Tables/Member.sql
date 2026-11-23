CREATE TABLE [dbo].[Member] (
    [Id]             INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AdoraMemberId]  INT            NOT NULL,
    [PartnerCode]    NVARCHAR (30)  NULL,
    [PartnerUserId]  VARCHAR (50)   NULL,
    [Email]          NVARCHAR (100) NULL,
    [Mobile]         VARCHAR (30)   NULL,
    [Status]         INT            NOT NULL,
    [CreatedOn]      DATETIME       NOT NULL,
    [LastModifiedOn] DATETIME       NOT NULL,
    [Version]        INT            NOT NULL,
    [LastSyncTime]   DATETIME       NULL,
    CONSTRAINT [PK_Member_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UK_Member_AdoraMemberId] UNIQUE NONCLUSTERED ([AdoraMemberId] ASC),
    CONSTRAINT [UK_Member_Mobile] UNIQUE NONCLUSTERED ([Mobile] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1--Active
   2--Inactive', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Member', @level2type = N'COLUMN', @level2name = N'Status';

