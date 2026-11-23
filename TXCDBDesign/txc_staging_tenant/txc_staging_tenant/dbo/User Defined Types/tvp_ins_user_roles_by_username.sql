CREATE TYPE [dbo].[tvp_ins_user_roles_by_username] AS TABLE (
    [TenantId] INT            NOT NULL,
    [RoleId]   INT            NOT NULL,
    [UserName] NVARCHAR (250) NOT NULL);

