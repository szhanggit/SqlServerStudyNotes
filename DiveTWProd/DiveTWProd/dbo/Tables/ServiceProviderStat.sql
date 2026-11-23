CREATE TABLE [dbo].[ServiceProviderStat] (
    [Id]                   INT         IDENTITY (1, 1) NOT NULL,
    [ServiceProviderId]    INT         NOT NULL,
    [ConsumerId]           INT         NOT NULL,
    [StatisticsDate]       VARCHAR (8) NULL,
    [StatisticsTime]       VARCHAR (6) NULL,
    [TotalSuccessMessages] INT         NULL,
    [TotalFailMessages]    INT         NULL,
    [MinResponseTime]      BIGINT      NULL,
    [MaxResponseTime]      BIGINT      NULL,
    [AverageResponseTime]  BIGINT      NULL,
    CONSTRAINT [PK_SERVICEPROVIDERSTAT] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ServiceProviderStat_Consumer_ConsumerId] FOREIGN KEY ([ConsumerId]) REFERENCES [dbo].[Consumer] ([Id]),
    CONSTRAINT [FK_ServiceProviderStatistics_ServiceProvider_ServiceProviderId] FOREIGN KEY ([ServiceProviderId]) REFERENCES [dbo].[ServiceProvider] ([Id])
);

