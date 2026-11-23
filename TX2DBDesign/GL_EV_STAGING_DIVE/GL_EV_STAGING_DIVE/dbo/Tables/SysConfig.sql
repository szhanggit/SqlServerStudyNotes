CREATE TABLE [dbo].[SysConfig] (
    [Id]    INT            IDENTITY (1, 1) NOT NULL,
    [Code]  NVARCHAR (30)  NOT NULL,
    [Value] NVARCHAR (300) NOT NULL,
    CONSTRAINT [PK_SystemConfig] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UK_SystemConfig_Code] UNIQUE NONCLUSTERED ([Code] ASC)
);

