
CREATE PROCEDURE [dbo].[spBKFailedSyncedVouchers] 
	@VoucherList VoucherSyncType READONLY
	,@IsSuccess INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRAN
	BEGIN TRY

insert into VoucherSyncFailedLog ([ProgramCode],
		[VoucherNumber],
		[BalanceAvailable],
		[BalanceFrozen],
		[Status],
		[PublishedOn],
		[ActivatedOn],
		[ExpiryDate],
		[ConsumeTime],
		[ConsumeMerchantCode],
		[ConsumeShopCode],
		[ConsumeTerminalSSN],
		[LastTranOn],
		[CreatedDate],
		[SessionId]) 		
select [ProgramCode],
		[VoucherNumber],
		[BalanceAvailable],
		[BalanceFrozen],
		[Status],
		[PublishedOn],
		[ActivatedOn],
		[ExpiryDate],
		[ConsumeTime],
		[ConsumeMerchantCode],
		[ConsumeShopCode],
		[ConsumeTerminalSSN],
		[LastTranOn],
		GETDATE() as [CreatedDate],
		NEWID() as [SessionId] from @VoucherList
		
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
