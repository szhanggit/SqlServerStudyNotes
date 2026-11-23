CREATE TABLE [dbo].[CSUserActionlog] (
    [Id]        BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [RequestId] VARCHAR (50) NOT NULL,
    [IPAddress] VARCHAR (50) NOT NULL,
    [CSUserId]  INT          NOT NULL,
    [Action]    VARCHAR (50) NOT NULL,
    [CreatedOn] DATETIME     NOT NULL,
    CONSTRAINT [PK_CSUserActionlog_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CSUserActionlog_CSUser_CSUserId] FOREIGN KEY ([CSUserId]) REFERENCES [dbo].[CSUser] ([Id])
);

