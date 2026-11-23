CREATE TABLE [dbo].[Monitor_AlertChannel] (
    [Id]              INT            IDENTITY (1, 1) NOT NULL,
    [MonitorTargetId] INT            NOT NULL,
    [ChannelName]     NVARCHAR (100) NOT NULL,
    [ChannelConfig]   NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Monitor_AlertChannel_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AlertChannel_BatchInfo_MonitorTargetId] FOREIGN KEY ([MonitorTargetId]) REFERENCES [dbo].[Monitor_BatchInfo] ([Id])
);

