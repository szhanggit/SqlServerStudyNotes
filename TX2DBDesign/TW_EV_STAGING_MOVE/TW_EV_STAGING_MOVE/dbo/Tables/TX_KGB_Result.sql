CREATE TABLE [dbo].[TX_KGB_Result] (
    [Id]             INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]           NVARCHAR (200) NOT NULL,
    [Result]         BIGINT         NULL,
    [Mark]           BIGINT         NOT NULL,
    [MarkOperation]  SMALLINT       NOT NULL,
    [IsActive]       BIT            NOT NULL,
    [LastUpdateTime] DATETIME       NULL,
    [NotifyChannel]  INT            NULL,
    [Level]          INT            NULL,
    [message]        NVARCHAR (500) NULL
);


GO
	CREATE TRIGGER Record_KGB_Result ON dbo.TX_KGB_Result
		FOR UPDATE
	AS 
		IF EXISTS (SELECT 1 FROM Inserted)
		BEGIN
			INSERT INTO dbo.KGB_Result_History
					( AlertName ,
					  AlertId ,
					  Env ,
					  Result ,
					  UpdateTime ,
					  CreateTime ,
					  NeedAlert
					)				
					select re.[Name] as AlertName
					, ch.Id as AlertId
					, ch.DBKey as Env
					, re.Result
					, re.LastUpdateTime as UpdateTime
					, GETDATE() as CreateTime 
					, (CASE WHEN re.MarkOperation = 0 AND re.Result >= re.Mark THEN 1 else 
					   case when re.MarkOperation = 1 AND re.Result != re.Mark THEN 1 else 
					   case when re.MarkOperation = 2 AND re.Result < re.Mark THEN 1 else 0 end end end) [NeedAlert]
					from Inserted re with(nolock)
					inner join TX_KGB_CheckInfo ch with(nolock) on re.Id = ch.Id
					where ch.IsActive = 1 AND ch.[Name] in (
					'CheckBizAPI',
					'CheckJsonAPI',
					'CheckPosAPI',
					'CheckSVAPI',
					'CheckJsonAPINode1',
					'CheckJsonAPINode2'
					)						
		END