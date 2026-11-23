CREATE TYPE [dbo].[tvp_ins_admin_user_roles_by_username] AS TABLE (
    [TenantId]        INT      NOT NULL,
    [AppId]           INT      NOT NULL,
    [RoleId]          INT      NOT NULL,
    [RoleStatus]      INT      NOT NULL,
    [TenantAppStatus] INT      NOT NULL,
    [ActiveDate]      DATETIME NULL,
    [ExpirationDate]  DATETIME NULL);

