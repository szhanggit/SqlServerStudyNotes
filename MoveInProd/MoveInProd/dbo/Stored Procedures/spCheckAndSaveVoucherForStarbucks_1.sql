
CREATE PROCEDURE [dbo].[spCheckAndSaveVoucherForStarbucks]
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
		DELETE FROM EXT_TW_Starbucks_Buffer WHERE SessionId = @SessionId;
		RETURN;
	END
	
	IF(EXISTS(SELECT 1 FROM VoucherImpTemp vt JOIN Voucher v ON vt.ProgramId = v.ProgramId AND vt.VoucherNumber = v.VoucherNumber WHERE vt.SessionId = @SessionId))
	BEGIN
		SELECT DISTINCT TOP 50 VIT.VoucherNumber
		FROM VoucherImpTemp AS VIT JOIN Voucher AS V ON VIT.ProgramId = V.ProgramId AND VIT.VoucherNumber = V.VoucherNumber
		WHERE VIT.SessionId = @SessionId

		DELETE FROM VoucherImpTemp WHERE SessionId = @SessionId;
		DELETE FROM EXT_TW_Starbucks_Buffer WHERE SessionId = @SessionId;
		RETURN;
	END
	
	BEGIN TRY
		BEGIN TRANSACTION
		
			INSERT INTO Voucher
			(
				ProgramId,
				VoucherNumber,
				ProductId,
				BalanceAvailable,
				[Status],
				ExpiryDate,
				[GUID],
				ReservationBatchId
			)
			SELECT
				VIT.ProgramId,
				VIT.VoucherNumber,
				VIT.ProductId,
				VIT.BalanceAvailable,
				VIT.[Status],
				DATEADD(SECOND, -1, DATEADD(DAY, 1, CONVERT(DATETIME, SBT.ExpiryDate))),
				NEWID(),
				VIT.ReservationBatchId
			FROM VoucherImpTemp AS VIT
			JOIN EXT_TW_Starbucks_Buffer AS SBT
				ON VIT.VoucherNumber = SBT.VoucherNumber AND VIT.ProgramId = SBT.ProgramId
			WHERE VIT.SessionId = @SessionId
			
			INSERT INTO EXT_TW_Starbucks
			(
				Id,
				DownloadURL,
				AuthCode,
				ExpiryDate,
				QRCode
			)
			SELECT
				V.Id,
				SBT.DownloadURL,
				SBT.AuthCode,
				SBT.ExpiryDate,
				SBT.QRCode
			FROM EXT_TW_Starbucks_Buffer AS SBT
			JOIN Voucher AS V 
				ON SBT.VoucherNumber = V.VoucherNumber AND SBT.ProgramId = V.ProgramId
			WHERE SBT.SessionId = @SessionId
			
			DELETE FROM VoucherImpTemp WHERE SessionId = @SessionId
			DELETE FROM EXT_TW_Starbucks_Buffer WHERE SessionId = @SessionId
		
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
	END CATCH
END

