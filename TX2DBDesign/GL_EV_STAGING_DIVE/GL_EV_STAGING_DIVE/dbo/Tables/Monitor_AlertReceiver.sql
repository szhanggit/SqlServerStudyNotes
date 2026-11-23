CREATE TABLE [dbo].[Monitor_AlertReceiver] (
    [Id]             INT            IDENTITY (1, 1) NOT NULL,
    [AlertChannelId] INT            NOT NULL,
    [Receiver]       NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK_Monitor_AlertReceiver_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_AlertReceiver_AlertChannel_AlertChannelId] FOREIGN KEY ([AlertChannelId]) REFERENCES [dbo].[Monitor_AlertChannel] ([Id])
);

