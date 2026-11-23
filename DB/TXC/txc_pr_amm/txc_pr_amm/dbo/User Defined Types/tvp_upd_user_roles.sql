CREATE TYPE [dbo].[tvp_upd_user_roles] AS TABLE (
    [UserRoleId]     INT      NOT NULL,
    [UserId]         INT      NOT NULL,
    [RoleId]         INT      NOT NULL,
    [RoleActive]     DATETIME NULL,
    [RoleExpiration] DATETIME NULL,
    [RoleStatus]     INT      NOT NULL,
    [IsAssigned]     BIT      NOT NULL,
    [AppId]          INT      NOT NULL,
    [TenantId]       INT      NOT NULL);

