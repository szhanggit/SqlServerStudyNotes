CREATE TABLE [dbo].[UpdateVoucherStatusForClearCacheBuffer] (
    [Id]     INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [TaskId] VARCHAR (100) NOT NULL,
    [Num]    INT           NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

