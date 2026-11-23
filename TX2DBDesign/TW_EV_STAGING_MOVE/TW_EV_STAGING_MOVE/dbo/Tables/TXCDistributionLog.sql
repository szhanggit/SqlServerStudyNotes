CREATE TABLE [dbo].[TXCDistributionLog] (
    [Id]              BIGINT         IDENTITY (1, 1) NOT NULL,
    [FileName]        VARCHAR (100)  NOT NULL,
    [Status]          INT            NOT NULL,
    [CreatedTime]     DATETIME       NOT NULL,
    [LastUpdatedTime] DATETIME       NULL,
    [Remarks]         NVARCHAR (500) NULL,
    CONSTRAINT [PK_TXCDistributionLog] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [UK_TXCDistributionLog] UNIQUE NONCLUSTERED ([FileName] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_TXCDistributionLog]
    ON [dbo].[TXCDistributionLog]([Status] ASC) WITH (FILLFACTOR = 90);

