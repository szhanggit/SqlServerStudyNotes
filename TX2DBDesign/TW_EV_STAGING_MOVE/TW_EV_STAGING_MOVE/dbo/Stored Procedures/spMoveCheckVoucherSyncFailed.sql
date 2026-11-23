CREATE PROCEDURE [dbo].[spMoveCheckVoucherSyncFailed]        
AS        
BEGIN    
  
SET NOCOUNT ON  
  
SELECT top 1 *   
FROM VoucherSyncFailedLog WITH(NOLOCK)  
  
END