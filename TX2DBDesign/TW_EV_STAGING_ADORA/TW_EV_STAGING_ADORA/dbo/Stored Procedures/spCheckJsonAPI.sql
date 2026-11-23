CREATE PROCEDURE [dbo].[spCheckJsonAPI]        
AS        
BEGIN        
      
SET NOCOUNT ON        
DECLARE @BatchName VARCHAR(100)        
SET @BatchName = 'CheckJsonAPI'        
        
;WITH cte AS (SELECT TOP 1000 *       
FROM APILog_Json WITH(NOLOCK)        
WHERE TranType != 'healthcheck'        
ORDER BY Id DESC)        
        
SELECT @BatchName AS [Name]      
 , COUNT(1) AS Result       
FROM cte        
WHERE (ResponseCode = '9999'       
 --OR ResponseCode = '0079'      
 OR DATEDIFF(MILLISECOND, CreatedOn, ResponsedOn) > 3000)      
AND CreatedOn > DATEADD(MINUTE, -1, GETDATE())         
        
END

