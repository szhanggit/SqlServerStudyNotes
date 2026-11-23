CREATE TABLE [dbo].[ServiceProvider] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [CountryId]          INT            NOT NULL,
    [SupportMessageType] INT            NOT NULL,
    [ProviderCode]       NVARCHAR (8)   NOT NULL,
    [ProviderName]       NVARCHAR (100) NOT NULL,
    [IsOpen]             BIT            NOT NULL,
    [NeedTrack]          BIT            NOT NULL,
    [AssemblyName]       VARCHAR (100)  NOT NULL,
    [FullTypeName]       VARCHAR (100)  NOT NULL,
    [CreatedOn]          DATETIME       NULL,
    [DisabledOn]         DATETIME       NULL,
    [CreatedBy]          NVARCHAR (50)  NULL,
    [DisabledBy]         NVARCHAR (50)  NULL,
    [Description]        NVARCHAR (500) NULL,
    [DLRFullTypeName]    VARCHAR (100)  NULL,
    CONSTRAINT [PK_ServiceProvider] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ServiceProvider_Dictionary_CountryId] FOREIGN KEY ([CountryId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [AK_UK_SERVICEPROVIDER_SERVICEP] UNIQUE NONCLUSTERED ([ProviderCode] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1--Email
   2--SMS
   3--MMS
   4--LMS', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ServiceProvider', @level2type = N'COLUMN', @level2name = N'SupportMessageType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '0--disabled
   1--enabled', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ServiceProvider', @level2type = N'COLUMN', @level2name = N'IsOpen';

