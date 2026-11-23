CREATE PROCEDURE spFindTransactionHistoryV2  
 -- Add the parameters for the stored procedure here  
 @AcountNumber  varchar(50)  
 ,@TranCode   varchar(50)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
 SELECT *
 FROM [dbo].[TransactionHistory] with(nolock)
 WHERE [AccountNumber] = @AcountNumber AND [TranCode] = @TranCode  
END  