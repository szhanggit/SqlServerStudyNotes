CREATE PROCEDURE spBulkInsertOBI
	@OrderBeneficiaryInfo OrderBeneficiaryInfoInsertType READONLY
	,@IsSuccess INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRAN
	BEGIN TRY


	insert into OrderBeneficiaryInfo (OrderLineId, ActiveDate, Mobile, Email, FaceValue, FaceValueWithTax, SoldPrice, SoldPriceWithTax, VoucherQuantity, ExpirySchemeId, ExpiryDate, ClientOrderNumber, Memo, [Name], [Address], PostCode, EDOrderNumber, LanguageId)
	select OrderLineId, ActiveDate, Mobile, Email, FaceValue, FaceValueWithTax, SoldPrice, SoldPriceWithTax, VoucherQuantity, ExpirySchemeId, ExpiryDate, ClientOrderNumber, Memo, [Name], [Address], PostCode, EDOrderNumber, LanguageId
	from @OrderBeneficiaryInfo

		
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