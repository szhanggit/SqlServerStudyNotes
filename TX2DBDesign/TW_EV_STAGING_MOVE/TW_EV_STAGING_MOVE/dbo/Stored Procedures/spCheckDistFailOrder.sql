CREATE PROCEDURE dbo.spCheckDistFailOrder    
AS    
BEGIN    
 SET NOCOUNT ON;    
    
 DECLARE @table TABLE(    
  OrderId INT NOT NULL,    
  OrderNumber VARCHAR(50) NOT NULL    
 )    
     
 INSERT @table    
 (    
     OrderId,    
     OrderNumber    
 )    
 SELECT Id, OrderNumber       
  FROM dbo.[Order] WITH(NOLOCK) WHERE     
   Status = 32 AND    
   ExecutingStatus = 7 AND    
   CreatedOn > DATEADD(day, -3, GETDATE()) AND     
   PublishDatetime < DATEADD(MINUTE, -30, GETDATE())    
  ORDER BY Id DESC;    
     
 DECLARE @message VARCHAR(100);    
 IF EXISTS (SELECT 1 FROM @table)    
 BEGIN    
  DECLARE @dbprefix VARCHAR(2) = (Select LEFT(name, 2) From sys.SysDataBases Where DbId=(Select Dbid From sys.SysProcesses Where Spid = @@spid))    
  SET @message = @dbprefix + ' PROD Order ' + (SELECT TOP (3) OrderNumber + ',' FROM @table for xml path('')) + ' DistributeFail';    
 END    
 SELECT N'CheckDistFailOrder' AS [Name], COUNT(1) AS Result FROM @table;    
END 

