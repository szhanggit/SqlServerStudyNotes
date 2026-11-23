ALTER ROLE [db_owner] ADD MEMBER [IN_EV_PROD_MOVE];


GO
ALTER ROLE [db_owner] ADD MEMBER [ZAEINTXINDBSP01\MOVE_REPL];


GO
ALTER ROLE [db_datareader] ADD MEMBER [IN_EV_DBS_MOVREP];


GO
ALTER ROLE [db_datareader] ADD MEMBER [stzhang];


GO
ALTER ROLE [db_datareader] ADD MEMBER [IN_EV_PROD_ADORA];


GO
ALTER ROLE [db_datareader] ADD MEMBER [sa-ein-txrepl];

