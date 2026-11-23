CREATE TABLE [dbo].[Member] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [PartnerCode]      NVARCHAR (30)  NULL,
    [PartnerUserId]    VARCHAR (50)   NULL,
    [IDCardNo]         VARCHAR (20)   NOT NULL,
    [Email]            NVARCHAR (100) NULL,
    [Mobile]           VARCHAR (30)   NULL,
    [Status]           INT            NOT NULL,
    [CreatedOn]        DATETIME       NOT NULL,
    [LastModifiedOn]   DATETIME       NOT NULL,
    [PinCode]          VARCHAR (30)   NULL,
    [PinCodeCreatedOn] DATETIME       NULL,
    [Version]          INT            NOT NULL,
    CONSTRAINT [PK_Member_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [UK_Member_PartnerCode_PartnerUserId] UNIQUE NONCLUSTERED ([PartnerCode] ASC, [PartnerUserId] ASC) WITH (FILLFACTOR = 90)
);

