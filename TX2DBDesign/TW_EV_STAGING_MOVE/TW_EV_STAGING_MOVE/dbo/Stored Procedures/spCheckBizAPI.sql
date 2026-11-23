CREATE PROCEDURE [dbo].[spCheckBizAPI]              
AS              
BEGIN          
        
SET NOCOUNT ON        
DECLARE @BatchName VARCHAR(100);      
DECLARE @sqlCmd NVARCHAR(2000);  
DECLARE @table VARCHAR(100);  
        
SET @BatchName = 'CheckBizAPI'            
SET @table = 'APILog_' + CONVERT(VARCHAR(10),DATEPART(M,GETDATE()))  
  
SET @sqlCmd = ';WITH cte AS (SELECT TOP 1000 * ' +         
'FROM ' +  @table + ' WITH(nOLOCK) ' +              
'WHERE (OperationCode LIKE ''GetVoucher%'' ' +        
 'OR OperationCode LIKE ''GetMultiVoucher%'' ' +         
 'OR OperationCode LIKE ''SendVoucher%'' ' +         
 'OR OperationCode LIKE ''SendMultiVoucher%'') ' +              
'AND OperationCode NOT IN (''GetVoucherLayoutInfoByVoucherGuid'' ' +        
 ',''GetVoucherLayoutInfoByVoucherAlias'' ' +        
 ',''GetVoucherInfoByVoucherAlias'' ' +        
 ',''GetVoucherInfoByVoucherGuid'' ' +        
 ',''GetVoucherInfoWithGuide'' ' +       
 ',''GetVoucherInfoWithPwd'') ' +              
'ORDER BY Id DESC) ' +  
'SELECT ''' + @BatchName + ''' AS [Name] ' +        
 ',COUNT(1) AS Result ' +        
'FROM cte ' +             
'WHERE (ResponseCode = ''9999'' ' +        
 'OR ResponseCode = ''MA0033'' ' +    
 'OR ResponseCode = ''MA0038'' ' +    
 'OR DATEDIFF(MILLISECOND, CreatedOn, ResponsedOn) > 3000) ' +        
'AND CreatedOn > DATEADD(MINUTE, -1, GETDATE()) ' +        
'OR (ResponseCode IS NULL AND CreatedOn BETWEEN DATEADD(MINUTE, -1, DATEADD(SECOND, -3, GETDATE())) AND DATEADD(SECOND, -3, GETDATE()))'  
  
EXEC (@sqlCmd)        
              
END

