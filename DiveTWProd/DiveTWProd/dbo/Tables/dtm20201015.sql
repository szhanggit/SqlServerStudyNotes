CREATE TABLE [dbo].[dtm20201015] (
    [Id]                 INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [LocalId]            INT NULL,
    [DistributionTaskId] INT NULL,
    [DistributionStatus] INT NULL,
    [VoucherId]          INT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

