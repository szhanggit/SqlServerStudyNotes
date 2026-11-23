CREATE TABLE [dbo].[Program] (
    [Id]                    INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ExternalId]            VARCHAR (50)   NOT NULL,
    [IdentityCode]          VARCHAR (20)   NOT NULL,
    [Name]                  NVARCHAR (50)  NOT NULL,
    [DisplayName]           NVARCHAR (200) NULL,
    [TimeOffset]            VARCHAR (6)    NOT NULL,
    [MerchantMaxFailNumber] INT            NOT NULL,
    [ShopMaxFailNumber]     INT            NOT NULL,
    [TerminalMaxFailNumber] INT            NOT NULL,
    CONSTRAINT [PK_Program_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC),
    CONSTRAINT [UK_Program_IdentityCode] UNIQUE CLUSTERED ([IdentityCode] ASC)
);

