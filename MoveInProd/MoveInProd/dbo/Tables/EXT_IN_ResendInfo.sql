CREATE TABLE [dbo].[EXT_IN_ResendInfo] (
    [Id]           BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [RequestId]    VARCHAR (50)  NOT NULL,
    [DeliveryType] TINYINT       NOT NULL,
    [Source]       TINYINT       NOT NULL,
    [RCN]          VARCHAR (100) NOT NULL,
    [SlmsTaskId]   BIGINT        NULL,
    [EmailTaskId]  BIGINT        NULL,
    [CreatedTime]  DATETIME      NOT NULL,
    CONSTRAINT [PK_EXT_IN_ResendInfo] PRIMARY KEY CLUSTERED ([Id] ASC)
);

