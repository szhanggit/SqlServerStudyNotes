CREATE TABLE [dbo].[TrustAccountSetting] (
    [Id]                  INT           IDENTITY (1, 1) NOT NULL,
    [Name]                NVARCHAR (50) NOT NULL,
    [ProductIssuerType]   TINYINT       NOT NULL,
    [BusinessTypeIds]     VARCHAR (50)  NOT NULL,
    [BusinessModelIds]    VARCHAR (50)  NOT NULL,
    [SubBusinessModelIds] VARCHAR (50)  NULL,
    [ProductPrefixs]      VARCHAR (100) NULL,
    [TrustAccountBank]    INT           NOT NULL,
    [Status]              INT           NOT NULL,
    [CreateTime]          DATETIME      NOT NULL,
    [Creater]             NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_TrustAccountSetting_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

