CREATE TABLE [dbo].[Program_08_02] (
    [Id]                    INT            IDENTITY (1, 1) NOT NULL,
    [IdentityCode]          VARCHAR (20)   NOT NULL,
    [Name]                  NVARCHAR (50)  NOT NULL,
    [DisplayName]           NVARCHAR (200) NULL,
    [TimeOffset]            VARCHAR (6)    NOT NULL,
    [MerchantMaxFailNumber] INT            NOT NULL,
    [ShopMaxFailNumber]     INT            NOT NULL,
    [TerminalMaxFailNumber] INT            NOT NULL,
    [IsDefaultProgram]      BIT            NOT NULL
);

