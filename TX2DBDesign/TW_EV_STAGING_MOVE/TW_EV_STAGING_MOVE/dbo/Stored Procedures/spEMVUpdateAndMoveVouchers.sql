





CREATE PROCEDURE [dbo].[spEMVUpdateAndMoveVouchers]
	@vSession varchar(50)
	,@ObiId bigint
	,@ClientOrderLineId int
	,@IsSuccess BIT OUTPUT
AS
BEGIN
	declare @dateNow date = getdate()
	set @IsSuccess =  0
	BEGIN TRAN

	BEGIN TRY
	
	
update v 
set v.VSessionId = @vSession,
	BeneficiaryInfoId = @ObiId,
	[Status] = 1,
	PublishedOn=@dateNow,
	ActivatedOn=@dateNow,
	LastTranOn=@dateNow
from Voucher v
	join EMV_VoucherClientOrder e on e.VoucherNumber =v.VoucherNumber and e.ProgramId = v.ProgramId
where v.Status = 64 
	and v.BeneficiaryInfoId is null 
	and e.ClientOrderLineId = @ClientOrderLineId

insert into Voucher
	(ProgramId,VoucherNumber,ProductId,BeneficiaryInfoId,BalanceAvailable,BalanceFrozen,Status,PublishedOn,ActivatedOn,ExpiryDate,Memo,GUID,ReservationBatchId,LastTranOn,ShortUrl,AuthCode,ExtendId,VSessionId,PinCode)
SELECT e.[ProgramId]
      , e.[VoucherNumber]
      , e.[ProductId]
	  , @ObiId
      , e.[BalanceAvailable]
      , e.[BalanceFrozen]
      , e.[Status]
	  , @dateNow
	  , @dateNow
	  , e.[ExpiryDate]
	  , e.[Memo]
	  , e.[GUID]
	  , e.[ReservationBatchId]
	  , @dateNow
	  , e.[ShortUrl]
	  , e.[AuthCode]
	  , e.[ExtendId]
	  , @vSession
      , e.[PinCode]
FROM [dbo].[EMV_VoucherClientOrder] e 
	left join Voucher v on e.VoucherNumber =v.VoucherNumber and e.ProgramId = v.ProgramId
Where ClientOrderLineId = @ClientOrderLineId 
	and v.Id is null

-- IsSuccess = 1 if Voucher count == EMV_VoucherClientOrder count
-- otherwise, IsSuccess = 0
select 
	@IsSuccess = CASE
			WHEN count(e.Id) = count(v.Id) THEN 1
			ELSE 0
		END 
from [dbo].[EMV_VoucherClientOrder] e
left join Voucher v on v.VoucherNumber = e.VoucherNumber
where e.ClientOrderLineId = @ClientOrderLineId


-- try to insert again
IF (@IsSuccess = 0)
BEGIN

	insert into Voucher
		(ProgramId,VoucherNumber,ProductId,BeneficiaryInfoId,BalanceAvailable,BalanceFrozen,Status,PublishedOn,ActivatedOn,ExpiryDate,Memo,GUID,ReservationBatchId,LastTranOn,ShortUrl,AuthCode,ExtendId,VSessionId,PinCode)
	SELECT e.[ProgramId]
		  , e.[VoucherNumber]
		  , e.[ProductId]
		  , @ObiId
		  , e.[BalanceAvailable]
		  , e.[BalanceFrozen]
		  , e.[Status]
		  , @dateNow
		  , @dateNow
		  , e.[ExpiryDate]
		  , e.[Memo]
		  , e.[GUID]
		  , e.[ReservationBatchId]
		  , @dateNow
		  , e.[ShortUrl]
		  , e.[AuthCode]
		  , e.[ExtendId]
		  , @vSession
		  , e.[PinCode]
	FROM [dbo].[EMV_VoucherClientOrder] e 
		left join Voucher v on e.VoucherNumber =v.VoucherNumber and e.ProgramId = v.ProgramId
	Where ClientOrderLineId = @ClientOrderLineId 
		and v.Id is null
		
	select 
	@IsSuccess = CASE
			WHEN count(e.Id) = count(v.Id) THEN 1
			ELSE 0
		END 
	from [dbo].[EMV_VoucherClientOrder] e
	left join Voucher v on v.VoucherNumber = e.VoucherNumber
	where e.ClientOrderLineId = @ClientOrderLineId

END




	END TRY
        BEGIN CATCH
			set @IsSuccess =  0
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
				THROW;
        END CATCH;
	IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
END
