CREATE TYPE [dbo].[tvp_ins_user_roles_by_username] AS TABLE (
    [TenantId]            INT      NOT NULL,
    [AppId]               INT      NOT NULL,
    [TenantAppActive]     DATETIME NULL,
    [TenantAppExpiration] DATETIME NULL,
    [TenantAppStatus]     INT      NOT NULL,
    [RoleId]              INT      NOT NULL,
    [RoleActive]          DATETIME NULL,
    [RoleExpiration]      DATETIME NULL,
    [RoleStatus]          INT      NOT NULL);

