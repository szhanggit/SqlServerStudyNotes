CREATE TABLE [dbo].[TPCConfigDetail] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [TPCConfigId] INT            NOT NULL,
    [Category]    NVARCHAR (50)  NOT NULL,
    [Name]        NVARCHAR (50)  NOT NULL,
    [Value]       NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK_TPCConfigDetail_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TPCConfigDetail_TPCConfig_TPCConfigId] FOREIGN KEY ([TPCConfigId]) REFERENCES [dbo].[TPCConfig] ([Id]),
    CONSTRAINT [UK_TPCConfigDetail_Name] UNIQUE NONCLUSTERED ([Category] ASC, [Name] ASC, [TPCConfigId] ASC)
);

