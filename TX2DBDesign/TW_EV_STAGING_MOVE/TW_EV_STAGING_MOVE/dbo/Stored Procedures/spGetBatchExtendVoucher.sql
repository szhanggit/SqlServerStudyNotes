CREATE PROCEDURE [dbo].[spGetBatchExtendVoucher]
	 @VoucherId bigint  
	 AS  
	BEGIN  
		SELECT
			[VoucherId],
			[ExtendTimes],
			[BatchExtendId]
		from BatchExtendVoucher with(nolock)
		where VoucherId = @VoucherId
	END