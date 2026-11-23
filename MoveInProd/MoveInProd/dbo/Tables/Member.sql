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
    CONSTRAINT [PK_Member_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [UK_Member_AdoraMemberId] UNIQUE NONCLUSTERED ([AdoraMemberId] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [UK_Member_Mobile] UNIQUE NONCLUSTERED ([Mobile] ASC) WITH (FILLFACTOR = 90)
);

