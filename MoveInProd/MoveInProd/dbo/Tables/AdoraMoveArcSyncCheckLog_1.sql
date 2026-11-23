CREATE TABLE [dbo].[AdoraMoveArcSyncCheckLog] (
    [Id]               BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Token]            VARCHAR (100) NULL,
    [DateNum]          INT           NULL,
    [AdoraTranNum]     INT           NULL,
    [MoveArcTranNum]   INT           NULL,
    [UnSyncVoucherNum] INT           NULL,
    [CreatedDate]      DATETIME      NULL,
    [Status]           INT           NULL,
    CONSTRAINT [PK_AdoraMoveArcSyncCheckLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);

