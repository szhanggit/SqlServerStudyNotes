CREATE ROLE [db_executor]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [db_executor] ADD MEMBER [ishuang];


GO
ALTER ROLE [db_executor] ADD MEMBER [TW_EV_STAGING_MOVE];

