CREATE TABLE [dbo].[RolePermission] (
    [Id]           INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [RoleId]       INT NOT NULL,
    [PermissionId] INT NOT NULL,
    CONSTRAINT [PK_RolePermission] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_RolePermission_Permission_PermissionId] FOREIGN KEY ([PermissionId]) REFERENCES [dbo].[Permission] ([Id]),
    CONSTRAINT [FK_RolePermission_Role_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Role] ([Id])
);

