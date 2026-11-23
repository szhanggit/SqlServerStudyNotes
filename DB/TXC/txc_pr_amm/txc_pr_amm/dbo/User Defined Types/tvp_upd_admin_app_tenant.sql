CREATE TYPE [dbo].[tvp_upd_admin_app_tenant] AS TABLE (
    [UserTenantAppId] INT      NOT NULL,
    [UserRoleId]      INT      NOT NULL,
    [UserId]          INT      NOT NULL,
    [AppId]           INT      NOT NULL,
    [TenantId]        INT      NOT NULL,
    [AdminRoleId]     INT      NOT NULL,
    [ActiveDate]      DATETIME NULL,
    [ExpirationDate]  DATETIME NULL,
    [TenantAppStatus] INT      NOT NULL,
    [RoleStatus]      INT      NOT NULL,
    [IsAssigned]      BIT      NOT NULL);

