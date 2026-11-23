CREATE TABLE [dbo].[TXCOperationLog] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [OperationName]    VARCHAR (50)   NOT NULL,
    [OperationContext] VARCHAR (2000) NOT NULL,
    [Status]           INT            NOT NULL,
    [TriedCount]       INT            NOT NULL,
    [CreatedTime]      DATETIME       NOT NULL,
    [LastUpdatedTime]  DATETIME       NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IDX_TXCOperationLog_OperationName]
    ON [dbo].[TXCOperationLog]([OperationName] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IDX_TXCOperationLog_Status]
    ON [dbo].[TXCOperationLog]([Status] ASC) WITH (FILLFACTOR = 90);

