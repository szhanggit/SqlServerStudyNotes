CREATE TABLE [dbo].[SendinBlueDLR] (
    [Id]                BIGINT        IDENTITY (1, 1) NOT NULL,
    [WhatDate]          DATETIME      NOT NULL,
    [serviceProviderId] INT           NOT NULL,
    [country]           VARCHAR (10)  NOT NULL,
    [DLRType]           INT           NOT NULL,
    [offset]            BIGINT        NOT NULL,
    [quantity]          INT           NOT NULL,
    [limit]             INT           NOT NULL,
    [eventType]         VARCHAR (50)  NOT NULL,
    [sort]              VARCHAR (10)  NOT NULL,
    [tag]               NVARCHAR (50) NULL,
    [Status]            INT           NOT NULL,
    [CreatedTime]       DATETIME      NOT NULL,
    [AnalyzedTime]      DATETIME      NULL,
    CONSTRAINT [PK_SendinBlueDLR_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [index_SendinBlueDLR_WhatDate]
    ON [dbo].[SendinBlueDLR]([WhatDate] DESC);

