Create PROCEDURE [dbo].[spCheckJsonAPINode2]        
AS        
BEGIN        
  
SET NOCOUNT ON        
DECLARE @BatchName VARCHAR(100)        
SET @BatchName = 'CheckJsonAPINode2'        
  
;WITH cte AS (SELECT TOP 1000 *      
FROM APILog_Json WITH(NOLOCK)        
WHERE TranType != 'healthcheck'        
ORDER BY Id DESC)        
      
SELECT @BatchName AS [Name]      
 , COUNT(1) AS Result      
FROM cte aj with(nolock)  
inner join MultiAccountsTransaction mat with(nolock) on aj.TerminalSSN = mat.TerminalSSN  
WHERE mat.NodeNum = 2 AND (aj.ResponseCode = '9999'      
 OR DATEDIFF(MILLISECOND, CreatedOn, ResponsedOn) > 3000)      
AND CreatedOn > DATEADD(MINUTE, -1, GETDATE())    
  
END

