CREATE TABLE [dbo].[LoadCacheInfo] (
    [Id]       BIGINT         IDENTITY (1, 1) NOT NULL,
    [CacheKey] NVARCHAR (250) NOT NULL,
    CONSTRAINT [PK_LoadCacheInfo_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

