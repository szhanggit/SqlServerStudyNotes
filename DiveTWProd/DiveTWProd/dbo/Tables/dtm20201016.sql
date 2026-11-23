CREATE TABLE [dbo].[dtm20201016] (
    [Id]                 INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [LocalId]            INT      NULL,
    [DistributionTaskId] INT      NULL,
    [DistributionStatus] INT      NULL,
    [VoucherId]          INT      NULL,
    [IssueDate]          DATETIME NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-dtm20201016]
    ON [dbo].[dtm20201016]([LocalId] ASC)
    INCLUDE([DistributionTaskId], [DistributionStatus], [VoucherId], [IssueDate]);

