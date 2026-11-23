CREATE TYPE [dbo].[tvp_upd_user_app_tenant] AS TABLE (
    [UserTenantAppId]     INT      NOT NULL,
    [UserId]              INT      NOT NULL,
    [AppId]               INT      NOT NULL,
    [TenantId]            INT      NOT NULL,
    [TenantAppActive]     DATETIME NULL,
    [TenantAppExpiration] DATETIME NULL,
    [TenantAppStatus]     INT      NOT NULL);

