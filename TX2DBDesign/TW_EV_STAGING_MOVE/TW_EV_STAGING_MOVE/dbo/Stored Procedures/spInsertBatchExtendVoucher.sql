CREATE PROCEDURE [dbo].[spInsertBatchExtendVoucher]
	 @VoucherId bigint  
	 ,@BatchExtendIds NVARCHAR (50) 
	 AS  
	BEGIN  
		INSERT INTO BatchExtendVoucher ([VoucherId], [ExtendTimes], [BatchExtendId])
		SELECT @VoucherId, 1, @BatchExtendIds
	END