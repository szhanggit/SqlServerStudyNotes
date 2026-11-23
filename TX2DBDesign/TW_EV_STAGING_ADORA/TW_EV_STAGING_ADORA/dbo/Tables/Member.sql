CREATE TABLE [dbo].[Member] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [PartnerCode]      NVARCHAR (30)  NULL,
    [PartnerUserId]    VARCHAR (50)   NULL,
    [Email]            NVARCHAR (100) NULL,
    [Mobile]           VARCHAR (30)   NULL,
    [Status]           INT            NOT NULL,
    [CreatedOn]        DATETIME       NOT NULL,
    [LastModifiedOn]   DATETIME       NOT NULL,
    [PinCode]          VARCHAR (30)   NULL,
    [PinCodeCreatedOn] DATETIME       NULL,
    [Version]          INT            NOT NULL,
    [IDCardNo]         VARCHAR (20)   NOT NULL,
    CONSTRAINT [PK_Member_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UK_Member_PartnerCode_PartnerUserId] UNIQUE NONCLUSTERED ([PartnerCode] ASC, [PartnerUserId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1--Active
   2--Inactive', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Member', @level2type = N'COLUMN', @level2name = N'Status';

