CREATE PROCEDURE spUpdateVoucherExpiryDate
	@NewVoucherExpiryDate VoucherExpiryDateUpdateType READONLY
	,@IsSuccess INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRAN
	BEGIN TRY


	update v 
	set ExpiryDate = t.ExpiryDate
	from @NewVoucherExpiryDate t 
	join Voucher v with(nolock) on v.VoucherNumber = t.VoucherNumber and v.ProgramID = t.ProgramID

		
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