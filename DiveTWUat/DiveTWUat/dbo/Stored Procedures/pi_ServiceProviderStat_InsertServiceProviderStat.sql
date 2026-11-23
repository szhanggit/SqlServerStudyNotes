CREATE  PROCEDURE pi_ServiceProviderStat_InsertServiceProviderStat
  
AS
BEGIN
/***
one service provider can just process one type message
***/
	DELETE FROM ServiceProviderStat 
	WHERE StatisticsDate =CONVERT (varchar(8),GETUTCDATE(),112)

--insert emial provider statistic
	INSERT INTO ServiceProviderStat
        (ServiceProviderId
		,ConsumerId
        ,StatisticsDate
        ,StatisticsTime
        ,TotalSuccessMessages
        ,TotalFailMessages
        ,MinResponseTime
        ,MaxResponseTime
        ,AverageResponseTime)
	SELECT 
	     total.ServiceProviderId
		,total.ConsumerId
        ,total.StatisticsDate
        ,total.StatisticsTime
        ,ISNULL(s.TotalSuccessMessages,0)
        ,ISNULL(f.TotalFailMessages,0)
        ,ISNULL(total.MinResponseTime,0)
        ,ISNULL(total.MaxResponseTime,0)
        ,ISNULL(total.AverageResponseTime,0)
	FROM 
		(select t.ServiceProviderId
			,t.ConsumerId 
			,CONVERT (varchar(8), GETUTCDATE(), 112) AS StatisticsDate
			,REPLACE (CONVERT(varchar(8),GETUTCDATE(),108),':','') AS StatisticsTime
			,MIN (DATEDIFF (millisecond,ActionStartDateTime, ActionEndDateTime)) AS MinResponseTime
			,MAX (DATEDIFF (millisecond,ActionStartDateTime, ActionEndDateTime)) AS MaxResponseTime
			,AVG (DATEDIFF (millisecond,ActionStartDateTime, ActionEndDateTime)) AS AverageResponseTime
		FROM Task t 
			left join EmailMessage t1 on t.id = t1.taskid 
			left join EmailMessageActionLog t2 ON t1.id =t2.MessageId
		WHERE  (t2.ActionType = 2 or t2.ActionType = 4)   --send or resend
		   and t2.ActionEndDate =  CONVERT (varchar(8), dateadd(day,-1,GETUTCDATE()), 112)
		   and t2.ActionResult in (1, 2) --1 fail, 2 success
		GROUP BY t.ServiceProviderId,t.ConsumerId) total
	    left join 
		(select t.ServiceProviderId
			,t.ConsumerId 
			,count(1) as TotalSuccessMessages
		FROM Task t 
			left join EmailMessage t1 on t.id = t1.taskid 
			left join EmailMessageActionLog t2 ON t1.id =t2.MessageId
		WHERE  (t2.ActionType = 2 or t2.ActionType = 4)   --send or resend
		   and t2.ActionEndDate =  CONVERT (varchar(8), dateadd(day,-1,GETUTCDATE()), 112)
		   and t2.ActionResult = 2 --2 success
		GROUP BY t.ServiceProviderId,t.ConsumerId) as  s
		on total.ServiceProviderId = s.ServiceProviderId And total.ConsumerId=s.ConsumerId 
		left join
		(select t.ServiceProviderId
			,t.ConsumerId 
			,count(1) as TotalFailMessages
		FROM Task t 
			left join EmailMessage t1 on t.id = t1.taskid 
			left join EmailMessageActionLog t2 ON t1.id =t2.MessageId
		WHERE (t2.ActionType = 2 or t2.ActionType = 4)   --send or resend
		   and t2.ActionEndDate =  CONVERT (varchar(8), dateadd(day,-1,GETUTCDATE()), 112)
		   and t2.ActionResult = 1 --1 fail
		GROUP BY t.ServiceProviderId,t.ConsumerId) as  f
		on total.ServiceProviderId = f.ServiceProviderId And total.ConsumerId=f.ConsumerId 


--insert SLMS service provider

	INSERT INTO ServiceProviderStat
        (ServiceProviderId
		,ConsumerId
        ,StatisticsDate
        ,StatisticsTime
        ,TotalSuccessMessages
        ,TotalFailMessages
        ,MinResponseTime
        ,MaxResponseTime
        ,AverageResponseTime)
 	SELECT 
	     total.ServiceProviderId
		,total.ConsumerId 
        ,total.StatisticsDate
        ,total.StatisticsTime
        ,ISNULL(s.TotalSuccessMessages,0)
        ,ISNULL(f.TotalFailMessages,0)
        ,ISNULL(total.MinResponseTime,0)
        ,ISNULL(total.MaxResponseTime,0)
        ,ISNULL(total.AverageResponseTime,0)
	FROM 
		(select t.ServiceProviderId
			,t.ConsumerId 
			,CONVERT (varchar(8), GETUTCDATE(), 112) AS StatisticsDate
			,REPLACE (CONVERT(varchar(6),GETUTCDATE(),108),':','') AS StatisticsTime
			,MIN (DATEDIFF (millisecond,ActionStartDateTime, ActionEndDateTime)) AS MinResponseTime
			,MAX (DATEDIFF (millisecond,ActionStartDateTime, ActionEndDateTime)) AS MaxResponseTime
			,AVG (DATEDIFF (millisecond,ActionStartDateTime, ActionEndDateTime)) AS AverageResponseTime
		FROM Task t 
			left join SLMSMessage t1 on t.id = t1.taskid 
			left join SLMSMessageActionLog t2 ON t1.id =t2.MessageId
		WHERE  (t2.ActionType = 2 or t2.ActionType = 4)   --send or resend
		   and t2.ActionEndDate =  CONVERT (varchar(8), dateadd(day,-1,GETUTCDATE()), 112)
		   and t2.ActionResult in (1, 2) --1 fail, 2 success
		GROUP BY t.ServiceProviderId,t.ConsumerId) total
		left join    
		(select t.ServiceProviderId
			,t.ConsumerId 
			,count(1) as TotalSuccessMessages
		FROM Task t 
			left join SLMSMessage t1 on t.id = t1.taskid 
			left join SLMSMessageActionLog t2 ON t1.id =t2.MessageId
		WHERE (t2.ActionType = 2 or t2.ActionType = 4)   --send or resend
		   and t2.ActionEndDate =  CONVERT (varchar(8), dateadd(day,-1,GETUTCDATE()), 112)
		   and t2.ActionResult = 2 --2 success
		GROUP BY t.ServiceProviderId,t.ConsumerId) as  s 
		on total.ServiceProviderId = s.ServiceProviderId And total.ConsumerId=s.ConsumerId 
		left join 
		(
		select t.ServiceProviderId
			,t.ConsumerId 
			,count(1) as TotalFailMessages
		FROM Task t 
			left join SLMSMessage t1 on t.id = t1.taskid 
			left join SLMSMessageActionLog t2 ON t1.id =t2.MessageId
		WHERE  (t2.ActionType = 2 or t2.ActionType = 4)   --send or resend
		   and t2.ActionEndDate =  CONVERT (varchar(8), dateadd(day,-1,GETUTCDATE()), 112)
		   and t2.ActionResult = 1 --1 fail
		GROUP BY t.ServiceProviderId,t.ConsumerId) as  f 
		on total.ServiceProviderId = f.ServiceProviderId And total.ConsumerId=f.ConsumerId      

End

