CREATE TABLE [dbo].[Shop20200522] (
    [Id]             INT            IDENTITY (1, 1) NOT NULL,
    [MerchantId]     INT            NOT NULL,
    [IdentityCode]   VARCHAR (50)   NOT NULL,
    [ExternalCode]   VARCHAR (50)   NULL,
    [Name]           NVARCHAR (100) NOT NULL,
    [AddressId]      INT            NOT NULL,
    [ContactName1]   NVARCHAR (50)  NULL,
    [ContactPhone1]  VARCHAR (50)   NULL,
    [ContactName2]   NVARCHAR (50)  NULL,
    [ContactPhone2]  VARCHAR (50)   NULL,
    [SecurityKey]    VARCHAR (48)   NULL,
    [CreatedOn]      DATETIME       NOT NULL,
    [LastModifiedOn] DATETIME       NOT NULL,
    [LastModifier]   NVARCHAR (50)  NOT NULL,
    [Status]         TINYINT        NOT NULL
);

