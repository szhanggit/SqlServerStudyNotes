CREATE TABLE [dbo].[TPCConfig] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [ProgramCode] VARCHAR (20)   NOT NULL,
    [Name]        NVARCHAR (50)  NOT NULL,
    [CallSetting] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_TPCConfig_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UK_TPCConfig_Name] UNIQUE NONCLUSTERED ([ProgramCode] ASC, [Name] ASC)
);

