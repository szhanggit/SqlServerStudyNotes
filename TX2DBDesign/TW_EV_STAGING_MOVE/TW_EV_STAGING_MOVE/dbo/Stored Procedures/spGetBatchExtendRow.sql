CREATE PROCEDURE [dbo].[spGetBatchExtendRow]
	 @BatchExtendId bigint  
	 AS  
	BEGIN  
		
		select btd.VoucherNumber, 
			   btd.ResponseCode, 
			   btd.VoucherGUID,
			   btd.ExpiryDate,
			   v.Id as VoucherId	   
		from BatchTransactionDetail btd with(nolock)
		join Program p with(nolock) on btd.ProgramCode = p.IdentityCode
		join Voucher v with(nolock) on v.VoucherNumber = btd.VoucherNumber and v.ProgramId = p.Id
		where BatchTransactionId in (			
			select BatchTransactionId
			from BatchExtendTransaction with(nolock) 
			where BatchExtendId = @BatchExtendId	
		)
		
	END