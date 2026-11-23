CREATE PROCEDURE [dbo].[spAdoraCheckAdoraTransactionArchive]      
AS      
BEGIN  

SET NOCOUNT ON

select * from Batch with(nolock) where BatchType = 2 AND [Status] != 8 AND StartTime > DATEADD(day,-1,GETutcDATE()) order by Id desc

END