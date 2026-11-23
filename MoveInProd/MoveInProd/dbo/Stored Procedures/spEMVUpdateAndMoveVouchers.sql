
CREATE PROCEDURE [dbo].[spEMVUpdateAndMoveVouchers]
	@vSession varchar(50)
	,@ObiId bigint
	,@ClientOrderLineId int
AS
BEGIN
	declare @dateNow date = getdate()
	BEGIN TRAN

	BEGIN TRY
update v set v.VSessionId = @vSession,BeneficiaryInfoId = @ObiId,[Status] = 1,PublishedOn=@dateNow,ActivatedOn=@dateNow,LastTranOn=@dateNow
from Voucher v
	join EMV_VoucherClientOrder e with(nolock) on e.VoucherNumber =v.VoucherNumber and e.ProgramId = v.ProgramId
where v.Status = 64 and v.BeneficiaryInfoId is null and e.ClientOrderLineId = @ClientOrderLineId

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
FROM [dbo].[EMV_VoucherClientOrder] e with(nolock)
	left join Voucher v with(nolock) on e.VoucherNumber =v.VoucherNumber and e.ProgramId = v.ProgramId
Where ClientOrderLineId = @ClientOrderLineId and v.Id is null

	END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
				THROW;
        END CATCH;
	IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
END
