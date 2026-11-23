CREATE TABLE [dbo].[SGUserRole] (
    [Id]     INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserId] INT NOT NULL,
    [RoleId] INT NOT NULL,
    CONSTRAINT [PK_SGUserRole] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_UserRole_Role_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Role] ([Id]),
    CONSTRAINT [FK_UserRole_User_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[SGUser] ([Id])
);

