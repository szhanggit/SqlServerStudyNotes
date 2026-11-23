CREATE TABLE [dbo].[SyncTranFeeProcess] (
    [Id]               INT          IDENTITY (1, 1) NOT NULL,
    [OlapFeeStartId]   BIGINT       NOT NULL,
    [OlapFeeEndId]     BIGINT       NOT NULL,
    [LastMaxTranFeeId] BIGINT       NOT NULL,
    [ThisMaxTranFeeId] BIGINT       NOT NULL,
    [DataCount]        INT          NOT NULL,
    [Status]           INT          NOT NULL,
    [CreateTime]       DATETIME     NOT NULL,
    [SessionId]        VARCHAR (40) NOT NULL,
    CONSTRAINT [PK_SyncTranFeeProcess_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

