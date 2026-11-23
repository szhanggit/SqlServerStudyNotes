
CREATE PROCEDURE [dbo].[spCheckAndSaveVoucherForSoftWorld]
	@SessionId VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;	

	IF(EXISTS(SELECT 1 FROM VoucherImpTemp WHERE SessionId = @SessionId GROUP BY VoucherNumber, ProgramId HAVING COUNT(VoucherNumber) > 1))
	BEGIN
		SELECT VoucherNumber
		FROM VoucherImpTemp
		WHERE SessionId = @SessionId
		GROUP BY VoucherNumber, SessionId, ProgramId
		HAVING COUNT(VoucherNumber) > 1

		DELETE FROM VoucherImpTemp WHERE SessionId = @SessionId;
		DELETE FROM EXT_TW_SoftWorld_Buffer WHERE SessionId = @SessionId;
		RETURN;
	END

	IF(EXISTS(SELECT 1 FROM VoucherImpTemp vt JOIN Voucher v ON vt.ProgramId = v.ProgramId AND vt.VoucherNumber = v.VoucherNumber WHERE vt.SessionId = @SessionId))
	BEGIN
		SELECT DISTINCT TOP 50  VIT.VoucherNumber
		FROM VoucherImpTemp AS VIT JOIN Voucher AS V ON VIT.ProgramId = V.ProgramId  AND VIT.VoucherNumber = V.VoucherNumber 
		WHERE VIT.SessionId = @SessionId

		DELETE FROM VoucherImpTemp WHERE SessionId = @SessionId;
		DELETE FROM EXT_TW_SoftWorld_Buffer WHERE SessionId = @SessionId;
		RETURN;
	END

	BEGIN TRY	
		BEGIN TRANSACTION

			INSERT INTO Voucher
			(
				ProgramId,
				VoucherNumber,
				ProductID,
				BalanceAvailable,
				[Status],
				[GUID],
				ReservationBatchId
				,ExpiryDate
			)
			SELECT 
				ProgramId,
				VoucherNumber,
				ProductID,
				BalanceAvailable,
				[Status],
				NEWID(),
				ReservationBatchId,
				ExpiryDate
			FROM VoucherImpTemp
			WHERE SessionId = @SessionId;

			INSERT INTO EXT_TW_SoftWorld
			(
				Id,
				Barcode1,
				Barcode2,
				CreatedOn,
				TrustStartDate,
				TrustEndDate
			)
			SELECT 
				V.Id,
				SEBT.Barcode1,
				SEBT.Barcode2,
				GETDATE() AS CreatedOn,
				TrustStartDate,
				TrustEndDate
			FROM EXT_TW_SoftWorld_Buffer AS SEBT
			JOIN Voucher AS V
				ON SEBT.VoucherNumber = V.VoucherNumber AND SEBT.ProgramId = V.ProgramId
			WHERE SessionId = @SessionId;
			
			DELETE FROM VoucherImpTemp WHERE SessionId = @SessionId;
			DELETE FROM EXT_TW_SoftWorld_Buffer WHERE SessionId = @SessionId;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
			ROLLBACK TRANSACTION;
	END CATCH		

END

