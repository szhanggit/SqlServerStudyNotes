-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[spCheckAndSaveVoucherNumber]
	@SessionId VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;	
	DECLARE @DuplicateNum  INT;
	SET @DuplicateNum = 0;

	IF(EXISTS(SELECT 1 FROM VoucherImpTemp WHERE SessionId = @SessionId GROUP BY VoucherNumber HAVING COUNT(VoucherNumber) > 1))
	BEGIN
		SELECT  VoucherNumber
		FROM VoucherImpTemp
		WHERE SessionId = @SessionId
		GROUP BY VoucherNumber,SessionId
		HAVING COUNT(VoucherNumber) > 1

		DELETE VoucherImpTemp WHERE SessionId =@SessionId ;
		RETURN;
	END

	IF(EXISTS(SELECT 1 FROM VoucherImpTemp vt join voucher v on vt.ProductId = v.ProductId and vt.VoucherNumber=v.VoucherNumber WHERE vt.SessionId = @SessionId))
	BEGIN
		SELECT distinct top 50  VIT.VoucherNumber
		FROM VoucherImpTemp AS VIT JOIN Voucher AS V ON VIT.productId = V.productId  AND VIT.VoucherNumber = V.VoucherNumber 
		WHERE VIT.SessionId = @SessionId

		DELETE VoucherImpTemp WHERE SessionId =@SessionId ;

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

			DELETE VoucherImpTemp WHERE SessionId =@SessionId ;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
			ROLLBACK TRANSACTION;
	END CATCH		

END
