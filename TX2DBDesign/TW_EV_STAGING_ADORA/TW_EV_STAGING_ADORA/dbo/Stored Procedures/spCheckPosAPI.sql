CREATE PROCEDURE [dbo].[spCheckPosAPI]        
AS        
BEGIN        
      
SET NOCOUNT ON        
DECLARE @BatchName VARCHAR(100)       
DECLARE @MaxId INT;       
SET @BatchName = 'CheckPosAPI'         
      
SELECT @MaxId = MAX(Id)       
FROM APILog_POS WITH(NOLOCK)       
WHERE RequestId IS NULL;        
      
SELECT @BatchName AS [Name]      
 ,COUNT(1) AS Result       
FROM APILog_POS WITH(NOLOCK)        
WHERE RequestId IS NULL       
AND Id > @MaxId - 1000       
AND (ResponseCode = '9999'      
 OR ResponseCode = '0003'      
 OR DATEDIFF(MILLISECOND, CreatedOn, ResponsedOn) > 3000      
 OR (TranType = '901' AND DATEDIFF(MILLISECOND, CreatedOn, ResponsedOn) > 5000))       
AND TranType != 'healthcheck'        
AND CreatedOn > DATEADD(MINUTE, -1, GETDATE())      
        
END 

