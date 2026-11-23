CREATE TABLE [dbo].[NetCoreDLR] (
    [Id]            BIGINT         IDENTITY (1, 1) NOT NULL,
    [WhatDate]      DATETIME       NOT NULL,
    [Fromhour]      INT            NULL,
    [Tohour]        INT            NULL,
    [DLRType]       INT            NOT NULL,
    [DLRFetchedURL] VARCHAR (500)  NULL,
    [DLRFileName]   NVARCHAR (500) NULL,
    [Status]        INT            NOT NULL,
    [CreatedTime]   DATETIME       NOT NULL,
    [AnalyzedTime]  DATETIME       NULL,
    CONSTRAINT [PK_NetCoreDLR_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [index_NetCoreDLR_WhatDate]
    ON [dbo].[NetCoreDLR]([WhatDate] DESC);

