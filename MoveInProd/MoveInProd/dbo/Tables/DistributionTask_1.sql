CREATE TABLE [dbo].[DistributionTask] (
    [Id]                  BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MessageType]         TINYINT      NOT NULL,
    [ServiceProviderCode] NVARCHAR (8) NOT NULL,
    [Status]              TINYINT      NOT NULL,
    [SynchronizationTime] DATETIME     NULL,
    CONSTRAINT [PK_DISTRIBUTIONTASK] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_DistributionTask_Status]
    ON [dbo].[DistributionTask]([Status] ASC);

