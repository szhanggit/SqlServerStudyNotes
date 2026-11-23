CREATE TYPE [dbo].[tvp_edit_user_roles] AS TABLE (
    [UserRoleId] INT NOT NULL,
    [UserId]     INT NOT NULL,
    [RoleId]     INT NOT NULL,
    [TenantId]   INT NOT NULL);

