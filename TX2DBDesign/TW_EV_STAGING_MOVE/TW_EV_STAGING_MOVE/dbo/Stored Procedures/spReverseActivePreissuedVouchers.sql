
CREATE PROCEDURE [dbo].[spReverseActivePreissuedVouchers] @VoucherIds VARCHAR(500)
	,@Status INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @sql VARCHAR(max)

	SET @sql = 'UPDATE Voucher SET BeneficiaryInfoId =  NULL, Status = ' + CONVERT(VARCHAR, @Status) + ' WHERE Id IN (' + @VoucherIds + ')'

	BEGIN TRAN

	PRINT @sql

	EXEC (@sql)

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN

		RETURN - 1
	END
	ELSE
	BEGIN
		COMMIT TRAN

		RETURN 1
	END
END
