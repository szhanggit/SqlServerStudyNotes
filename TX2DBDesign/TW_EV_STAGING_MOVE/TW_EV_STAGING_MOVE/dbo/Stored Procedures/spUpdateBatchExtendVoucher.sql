CREATE PROCEDURE [dbo].[spUpdateBatchExtendVoucher]
	 @VoucherId bigint  
	 ,@ExtendTimes INT  
	 ,@BatchExtendIds NVARCHAR (50) 
	 AS  
	BEGIN  
		UPDATE BatchExtendVoucher 
		SET 
			ExtendTimes = @ExtendTimes,
			BatchExtendId = @BatchExtendIds
		WHERE 
			VoucherId = @VoucherId
	END