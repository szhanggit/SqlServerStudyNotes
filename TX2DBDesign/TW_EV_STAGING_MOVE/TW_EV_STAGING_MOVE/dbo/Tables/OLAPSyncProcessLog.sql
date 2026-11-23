CREATE TABLE [dbo].[OLAPSyncProcessLog] (
    [Id]               INT          IDENTITY (1, 1) NOT NULL,
    [OlapTranStartId]  BIGINT       NOT NULL,
    [OlapTranEndId]    BIGINT       NOT NULL,
    [MoveTranMaxId]    BIGINT       NOT NULL,
    [MoveTranFeeMaxId] BIGINT       NOT NULL,
    [TranCount]        INT          NOT NULL,
    [TranFeeCount]     INT          NOT NULL,
    [Status]           INT          NOT NULL,
    [CreateTime]       DATETIME     NOT NULL,
    [FinishTime]       DATETIME     NULL,
    [SessionId]        VARCHAR (40) NOT NULL,
    CONSTRAINT [PK_OLAPSyncProcessLog_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

