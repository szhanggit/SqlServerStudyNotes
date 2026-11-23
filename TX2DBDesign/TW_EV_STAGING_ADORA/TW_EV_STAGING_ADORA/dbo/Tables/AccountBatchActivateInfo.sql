CREATE TABLE [dbo].[AccountBatchActivateInfo] (
    [Id]                  BIGINT          IDENTITY (1, 1) NOT NULL,
    [StartSequenceNumber] BIGINT          NOT NULL,
    [EndSequenceNumber]   BIGINT          NOT NULL,
    [Status]              INT             NOT NULL,
    [Description]         NVARCHAR (1000) NOT NULL,
    [CreateUTCTime]       BIGINT          NOT NULL,
    CONSTRAINT [PK_AccountBatchActivateInfo] PRIMARY KEY CLUSTERED ([Id] ASC)
);

