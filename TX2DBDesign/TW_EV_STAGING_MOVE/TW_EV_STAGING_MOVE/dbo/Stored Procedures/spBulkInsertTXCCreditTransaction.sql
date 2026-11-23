CREATE PROCEDURE spBulkInsertTXCCreditTransaction  
 @TXCCreditTransaction TXCCreditTransactionInsertType READONLY  
 ,@IsSuccess INT OUTPUT  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 BEGIN TRAN  
 BEGIN TRY  
  

	insert into TXCCreditTransaction (ClientId, VoucherId, OrderId, OrderlineId, CreditAmount, SessionId)  
	select ClientId, VoucherId, OrderId, OrderlineId, CreditAmount, SessionId
	from @TXCCreditTransaction  
  
    
 END TRY  
 BEGIN CATCH  
  IF @@TRANCOUNT > 0  
  begin  
   set @IsSuccess = 0;  
   ROLLBACK TRANSACTION;     
  end  
 END CATCH;  
 IF @@TRANCOUNT > 0  
 begin  
  set @IsSuccess = 1;  
  COMMIT TRANSACTION;   
 end  
END  


