CREATE TABLE [dbo].[PreIssueBatchInfo] (
    [Id]                INT      IDENTITY (1, 1) NOT NULL,
    [ProgramId]         INT      NOT NULL,
    [ProductId]         INT      NOT NULL,
    [ReservationCodeId] INT      NOT NULL,
    [CacheNode]         INT      NOT NULL,
    [Status]            INT      NOT NULL,
    [LockTime]          DATETIME NOT NULL,
    CONSTRAINT [PK_PreIssueBatchInfo_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_PreIssueBatchInfo_ProductId]
    ON [dbo].[PreIssueBatchInfo]([ProductId] ASC);

