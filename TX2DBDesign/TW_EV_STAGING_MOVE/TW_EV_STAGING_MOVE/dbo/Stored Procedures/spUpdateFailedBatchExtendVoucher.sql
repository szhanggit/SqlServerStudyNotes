CREATE PROCEDURE [dbo].[spUpdateFailedBatchExtendVoucher]
	 @BatchExtendId int
	 AS  
	BEGIN  
		
update BatchExtendVoucher
set ExtendTimes = ExtendTimes-1
where VoucherId in
(
	select 
		v.Id
	from BatchExtend be with(nolock)
	join BatchExtendTransaction bet with(nolock) on be.Id = bet.BatchExtendId
	join BatchTransaction bt with(nolock) on bet.BatchTransactionId = bt.Id
	join BatchTransactionDetail btd with(nolock) on btd.BatchTransactionId = bt.Id
	join Program p with(nolock) on btd.ProgramCode = p.IdentityCode
	join Voucher v with(nolock) on btd.VoucherNumber = v.VoucherNumber and p.Id = v.ProgramId
	where btd.ResponseCode <> '0000' 
	and ResponseCode is not null
)

	END