CREATE TABLE [dbo].[AdoraLosingAcceptanceLoopLog] (
    [Id]              INT            IDENTITY (1, 1) NOT NULL,
    [ProcessDateTime] DATETIME       NOT NULL,
    [GUID]            NVARCHAR (100) NOT NULL,
    [type]            VARCHAR (10)   NOT NULL,
    [Desc]            NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

