-- =============================================
-- Author:		Lam
-- Create date: 2021/7/22
-- Description:	Executed by MOVE Batch InsertTransactionJob after processing reupload/reissue voucher
-- =============================================
CREATE PROCEDURE [dbo].[spUpdateBatchTransaction]
(
	@BatchTransactionDetailID BIGINT,
	@ResponseCode VARCHAR(5),
	@TranCode VARCHAR(50),
	@TranCodeRef VARCHAR(50),
	@ErrorMessage NVARCHAR(4000) OUTPUT,
	@ErrorLine INT OUTPUT
)
AS
BEGIN  
 SET NOCOUNT ON;  
  
 BEGIN TRAN  
 BEGIN TRY  
  -- Update BatchTransactionDetail.ResponseCode  
  UPDATE BatchTransactionDetail 
  SET ResponseCode = @ResponseCode,  
	  TranCode = @TranCode,
	  TranCodeRef = @TranCodeRef
  WHERE Id = @BatchTransactionDetailID AND ResponseCode = '9996' -- WaitingSynchronization  
  
  IF (@@TRANCOUNT = 0)  
  BEGIN  
   SELECT @ErrorMessage = 'Update BatchTransactionDetail failed';  
   SELECT @ErrorLine = 999;  
   ROLLBACK TRAN;  
   RETURN;  
  END  
  
  -- If success, increment BatchTransactionTask.SuccessVoucherCount and BatchTransaction.SuccessVoucherCount  
  IF (@ResponseCode = '0000')  
  BEGIN  
   UPDATE BTT SET SuccessVoucherCount = SuccessVoucherCount + 1  
   FROM BatchTransactionDetail BTD INNER JOIN BatchTransactionTask BTT ON BTD.BatchTransactionTaskId = BTT.Id  
   WHERE BTD.Id = @BatchTransactionDetailID  
  
   UPDATE BT SET SuccessVoucherCount = SuccessVoucherCount + 1  
   FROM BatchTransactionDetail BTD INNER JOIN BatchTransaction BT ON BTD.BatchTransactionId = BT.Id  
   WHERE BTD.Id = @BatchTransactionDetailID  
  END  
  
  -- If fail, increment BatchTransactionTask.FailVoucherCount and BatchTransaction.FailVoucherCount  
  ELSE  
  BEGIN  
   UPDATE BTT SET FailVoucherCount = FailVoucherCount + 1  
   FROM BatchTransactionDetail BTD INNER JOIN BatchTransactionTask BTT ON BTD.BatchTransactionTaskId = BTT.Id  
   WHERE BTD.Id = @BatchTransactionDetailID  
  
   UPDATE BT SET FailVoucherCount = FailVoucherCount + 1  
   FROM BatchTransactionDetail BTD INNER JOIN BatchTransaction BT ON BTD.BatchTransactionId = BT.Id  
   WHERE BTD.Id = @BatchTransactionDetailID  
  END  
  
  DECLARE @BatchTransactionId BIGINT  
  DECLARE @TotalVoucherCount INT, @SuccessVoucherCount INT, @FailVoucherCount INT  
  
  -- Check voucher count of BatchTransaction  
  SELECT @BatchTransactionId = BT.Id, @TotalVoucherCount = BT.TotalVoucherCount, @SuccessVoucherCount = ISNULL(BT.SuccessVoucherCount, 0), @FailVoucherCount = ISNULL(BT.FailVoucherCount, 0)  
  FROM BatchTransaction BT INNER JOIN BatchTransactionDetail BTD ON BT.Id = BTD.BatchTransactionId  
  WHERE BTD.Id = @BatchTransactionDetailID  
  
  -- If all vouchers have returned result, update BatchTransaction.Status to 3 (Finished)  
  IF (@TotalVoucherCount = @SuccessVoucherCount + @FailVoucherCount)  
  BEGIN  
   UPDATE BatchTransaction SET Status = 3 -- Finished  
   WHERE Id = @BatchTransactionId  
  END  

  COMMIT TRAN;  
 END TRY  
 BEGIN CATCH  
  SELECT @ErrorMessage = ERROR_MESSAGE();  
  SELECT @ErrorLine = ERROR_LINE();  
  ROLLBACK TRAN;  
 END CATCH  
END