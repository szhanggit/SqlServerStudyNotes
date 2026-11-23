CREATE TABLE [dbo].[ShopWork] (
    [ProgramId]    INT              NULL,
    [ExternalId]   VARCHAR (50)     NULL,
    [IdentityCode] VARCHAR (50)     NULL,
    [Name]         NVARCHAR (100)   NULL,
    [MerchantId]   INT              NOT NULL,
    [TimeOffset]   VARCHAR (6)      NOT NULL,
    [Telephone]    VARCHAR (50)     NULL,
    [Address]      NVARCHAR (100)   NULL,
    [Longitude]    FLOAT (53)       NULL,
    [Latitude]     FLOAT (53)       NULL,
    [SecurityKey]  VARCHAR (48)     NULL,
    [Status]       INT              NULL,
    [BatchId]      UNIQUEIDENTIFIER NOT NULL,
    [CreatedOn]    DATETIME         NOT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '0--Inactive
   1--Active', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ShopWork', @level2type = N'COLUMN', @level2name = N'Status';

