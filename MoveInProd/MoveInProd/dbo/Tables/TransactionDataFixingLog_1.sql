CREATE TABLE [dbo].[TransactionDataFixingLog] (
    [Id]             BIGINT   IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProcessingDate] DATETIME NULL,
    [DateNum]        INT      NULL,
    [Status]         INT      NULL,
    CONSTRAINT [PK_TransactionDataFixingLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);

