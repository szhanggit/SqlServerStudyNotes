CREATE PROCEDURE spBulkInsertTXCReverseCreditTransaction
 @TXCReverseCreditTransaction TXCCreditTransactionInsertType READONLY  
 ,@IsSuccess INT OUTPUT  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 BEGIN TRAN  
 BEGIN TRY  
  
  
	insert into TXCReverseCreditTransaction (ClientId, VoucherId, OrderId, OrderlineId, TransactionId, CreditAmount, SessionId)  
	select ClientId, VoucherId, OrderId, OrderlineId, TransactionId, CreditAmount, SessionId
	from @TXCReverseCreditTransaction  
  
    
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
