CREATE TABLE [dbo].[Address] (
    [Id]                INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [DetailAddressLine] NVARCHAR (500) NULL,
    [District]          NVARCHAR (100) NULL,
    [CityId]            INT            NULL,
    [StateOrProvinceId] INT            NULL,
    [Postcode]          NVARCHAR (20)  NULL,
    [CountryId]         INT            NULL,
    [Longitude]         FLOAT (53)     NULL,
    [Latitude]          FLOAT (53)     NULL,
    [Status]            TINYINT        NOT NULL,
    CONSTRAINT [PK_ADDRESS] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Address_Dictionary_CityId] FOREIGN KEY ([CityId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [FK_Address_Dictionary_CountryId] FOREIGN KEY ([CountryId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [FK_Address_Dictionary_StateOrProvinceId] FOREIGN KEY ([StateOrProvinceId]) REFERENCES [dbo].[Dictionary] ([Id])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '0--inactive
   1--active', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Address', @level2type = N'COLUMN', @level2name = N'Status';

