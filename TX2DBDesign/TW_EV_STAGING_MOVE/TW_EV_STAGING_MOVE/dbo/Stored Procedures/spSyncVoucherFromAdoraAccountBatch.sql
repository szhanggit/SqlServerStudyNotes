
CREATE PROCEDURE [dbo].[spSyncVoucherFromAdoraAccountBatch]    
AS    
BEGIN  
SET NOCOUNT ON  
 
WHILE (1=1)              
 BEGIN
	exec [dbo].[spSyncVoucherFromAdoraAccount]
	IF not exists (select * from VoucherSyncFailedLog with(nolock)) BREAK; 
 END 


END    