-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[spCheckAndSaveVoucherForFamilyMart]
	@SessionId VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;	

	IF(EXISTS(SELECT 1 FROM VoucherImpTemp WHERE SessionId = @SessionId GROUP BY VoucherNumber,ProgramId HAVING COUNT(VoucherNumber) > 1))
	BEGIN
		SELECT  VoucherNumber
		FROM VoucherImpTemp
		WHERE SessionId = @SessionId
		GROUP BY VoucherNumber,SessionId,ProgramId
		HAVING COUNT(VoucherNumber) > 1

		DELETE FROM VoucherImpTemp WHERE SessionId =@SessionId ;
		DELETE FROM EXT_TW_FamilyMart_Buffer WHERE SessionId =@SessionId ;
		RETURN;
	END

	IF(EXISTS(SELECT 1 FROM VoucherImpTemp vt join voucher v on vt.ProgramId = v.ProgramId and vt.VoucherNumber=v.VoucherNumber WHERE vt.SessionId = @SessionId))
	BEGIN
		SELECT DISTINCT TOP 50  VIT.VoucherNumber
		FROM VoucherImpTemp AS VIT JOIN Voucher AS V ON VIT.ProgramId = V.ProgramId  AND VIT.VoucherNumber = V.VoucherNumber 
		WHERE VIT.SessionId = @SessionId

		DELETE FROM VoucherImpTemp WHERE SessionId =@SessionId ;		
		DELETE FROM EXT_TW_FamilyMart_Buffer WHERE SessionId =@SessionId ;
		RETURN;
	END

	BEGIN TRY	
		BEGIN TRANSACTION

			INSERT INTO Voucher
						(ProgramId
						,VoucherNumber
						,ProductID
						,BalanceAvailable
						,[Status]
						,[GUID]
						,ReservationBatchId
						,ExpiryDate) 
			SELECT 
						ProgramId
						,VoucherNumber
						,ProductID
						,BalanceAvailable
						,[Status]
						,NEWID()
						,ReservationBatchId 
						,ExpiryDate
			FROM VoucherImpTemp
			WHERE SessionId =@SessionId;

			INSERT INTO EXT_TW_FamilyMart
						(Id
						, Barcode1
						, Barcode2
						, Barcode3
						, Barcode4
						, CreatedOn
						, ImportSessionId)
			SELECT 
						V.Id
						,SEBT.Barcode1
						,SEBT.Barcode2
						,SEBT.Barcode3
						,SEBT.Barcode4
						,GETDATE() AS CreatedOn
						,SessionId
			FROM EXT_TW_FamilyMart_Buffer AS SEBT
			JOIN Voucher AS V ON SEBT.VoucherNumber = V.VoucherNumber 
							  AND SEBT.ProgramId = V.ProgramId
			WHERE SessionId =@SessionId;
			
			DELETE FROM VoucherImpTemp WHERE SessionId =@SessionId ;
			DELETE FROM EXT_TW_FamilyMart_Buffer WHERE SessionId =@SessionId ;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
			ROLLBACK TRANSACTION;
	END CATCH		

END
