CREATE  PROCEDURE pi_ServiceProviderStat_InsertServiceProviderStat
  
AS
BEGIN
	DECLARE 
		@CurrentUtcDate	DATETIME,
		@StatisticsDate	VARCHAR(8),
		@ActionEndDate	VARCHAR(8),
		@StatisticsTime	VARCHAR(6)

	SET @CurrentUtcDate = GETUTCDATE()
	SET @StatisticsDate = CONVERT(varchar(8), @CurrentUtcDate, 112)
	SET @StatisticsTime = REPLACE(CONVERT(varchar(8), @CurrentUtcDate, 108), ':', '')
	SET @ActionEndDate = CONVERT (varchar(8), dateadd(day, -1, GETUTCDATE()), 112);

	DELETE FROM ServiceProviderStat 
	WHERE StatisticsDate = @StatisticsDate

	SELECT ServiceProviderId
		  ,ConsumerId
		  ,ResponseTime
		  ,FailNumber
		  ,SuccessNumber
		  ,[Type]
	INTO #Temp
	FROM (
		SELECT ServiceProviderId
			  ,ConsumerId
			  ,CAST(DATEDIFF (millisecond,ActionStartDateTime, ActionEndDateTime) AS BIGINT) ResponseTime
			  ,CASE EMAL.ActionResult WHEN 1 THEN 1 ELSE 0 END AS FailNumber
			  ,CASE EMAL.ActionResult WHEN 2 THEN 1 ELSE 0 END AS SuccessNumber
			  ,1 AS [Type]
		FROM Task T
		INNER join EmailMessage EM on T.id = EM.taskid 
		INNER join EmailMessageActionLog EMAL ON EM.id =EMAL.MessageId
		WHERE  EMAL.ActionType IN (2,4)   --send or resend
			and EMAL.ActionEndDate = @ActionEndDate
			and EMAL.ActionResult in (1,2) --1 fail, 2 success
		UNION ALL
		SELECT ServiceProviderId
			  ,ConsumerId
			  ,CAST(DATEDIFF (millisecond,ActionStartDateTime, ActionEndDateTime) AS BIGINT) ResponseTime
			  ,CASE SMAL.ActionResult WHEN 1 THEN 1 ELSE 0 END AS FailNumber
			  ,CASE SMAL.ActionResult WHEN 2 THEN 1 ELSE 0 END AS SuccessNumber 
			  ,2 AS [Type]
		FROM Task T
		INNER join SLMSMessage SM on T.id = SM.taskid 
		INNER join SLMSMessageActionLog SMAL ON SM.id =SMAL.MessageId
		WHERE  SMAL.ActionType IN (2,4)   --send or resend
			and SMAL.ActionEndDate = @ActionEndDate
			and SMAL.ActionResult in (1,2) --1 fail, 2 success
		) S

	INSERT INTO ServiceProviderStat
        (ServiceProviderId,ConsumerId,StatisticsDate,StatisticsTime,TotalSuccessMessages,TotalFailMessages,MinResponseTime,MaxResponseTime,AverageResponseTime)
	SELECT 
	     ServiceProviderId
		,ConsumerId
        ,@StatisticsDate
        ,@StatisticsTime
        ,ISNULL(s.TotalSuccessMessages,0)
        ,ISNULL(TotalFailMessages,0)
        ,ISNULL(MinResponseTime,0)
        ,ISNULL(MaxResponseTime,0)
        ,ISNULL(AverageResponseTime,0)
	FROM 
		(SELECT ServiceProviderId
			   ,ConsumerId
			   ,MIN(ResponseTime) AS MinResponseTime
			   ,MAX(ResponseTime) AS MaxResponseTime
			   ,AVG(ResponseTime) AS AverageResponseTime
			   ,SUM(FailNumber) AS TotalFailMessages
			   ,SUM(SuccessNumber) AS TotalSuccessMessages
		 FROM #Temp
		 GROUP BY ServiceProviderId, ConsumerId, [Type]) AS S

	DROP TABLE #Temp

End
