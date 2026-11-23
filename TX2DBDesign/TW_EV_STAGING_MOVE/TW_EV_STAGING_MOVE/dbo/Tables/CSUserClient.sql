CREATE TABLE [dbo].[CSUserClient] (
    [Id]        INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CSUserId]  INT      NOT NULL,
    [ClientId]  INT      NOT NULL,
    [CreatedOn] DATETIME NOT NULL,
    CONSTRAINT [PK_CSUserClient_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_CSUserClient_Client_ClientId] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([Id]),
    CONSTRAINT [FK_CSUserClient_CSUser_CSUserId] FOREIGN KEY ([CSUserId]) REFERENCES [dbo].[CSUser] ([Id])
);

