-- =============================================
-- Author:		<Author,Eagles>
-- Create date: <Create Date,2017-5-10>
-- Description:	<Description,Import Voucher For GR>
-- =============================================

CREATE PROCEDURE [dbo].[spCheckAndSaveVoucherForGR]
	@SessionId VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;	
	
	IF(EXISTS(SELECT 1 FROM EXT_GR_VoucherInfo_Buffer WHERE SessionId = @SessionId GROUP BY Ecode,ProgramId HAVING COUNT(Ecode) > 1))
	BEGIN
		SELECT  Ecode
		FROM EXT_GR_VoucherInfo_Buffer
		WHERE SessionId = @SessionId
		GROUP BY Ecode,ProgramId
		HAVING COUNT(Ecode) > 1

		DELETE FROM VoucherImpTemp WHERE SessionId =@SessionId ;
		DELETE FROM EXT_GR_VoucherInfo_Buffer WHERE SessionId =@SessionId ;
		RETURN;
	END

	IF(EXISTS(SELECT 1 FROM EXT_GR_VoucherInfo_Buffer vt join EXT_GR_VoucherInfo v on vt.Ecode = v.Ecode WHERE vt.SessionId = @SessionId))
	BEGIN
		SELECT DISTINCT TOP 50  VIT.Ecode
		FROM EXT_GR_VoucherInfo_Buffer AS VIT JOIN EXT_GR_VoucherInfo AS V ON VIT.Ecode = V.Ecode
		WHERE VIT.SessionId = @SessionId

		DELETE FROM VoucherImpTemp WHERE SessionId =@SessionId ;		
		DELETE FROM EXT_GR_VoucherInfo_Buffer WHERE SessionId =@SessionId ;
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
						VIP.ProgramId
						,REPLACE(LTRIM(VIP.VoucherNumber),'-','')--Vip.VoucherNumber is a Guid without '-'
						,ProductID
						,BalanceAvailable
						,[Status]
						,VIP.VoucherNumber
						,ReservationBatchId
						,DATEADD(SECOND,-1,DATEADD(DAY,1,CONVERT(DATETIME,GRVB.ExpiryDate)))
			FROM VoucherImpTemp VIP
			INNER JOIN EXT_GR_VoucherInfo_Buffer AS GRVB
			ON GRVB.SessionId = VIP.SessionId AND vip.VoucherNumber = GRVB.VoucherNumber
			WHERE VIP.SessionId =@SessionId;


			INSERT INTO EXT_GR_VoucherInfo
						(Id
						, Ecode
						, VName
						, Denomination
						, Vcurrency
						, Vpassword
						, Snumber
						, IssueDate
						, ExpiryDate
						, Vstatus
						, FinBookingCurrency
						, FinBookingValue
						, InvoiceNumber
						, PayToMerchant
						, Misc1
						, Misc2
						)
			SELECT 
						V.Id
						, GRVB.Ecode
						, GRVB.VName
						, GRVB.Denomination
						, GRVB.Vcurrency
						, GRVB.Vpassword
						, GRVB.Snumber
						, GRVB.IssueDate
						, GRVB.ExpiryDate
						, GRVB.Vstatus
						, GRVB.FinBookingCurrency
						, GRVB.FinBookingValue
						, GRVB.InvoiceNumber
						, GRVB.PayToMerchant
						, GRVB.Misc1
						, GRVB.Misc2
			FROM EXT_GR_VoucherInfo_Buffer AS GRVB
			JOIN Voucher AS V ON GRVB.VoucherNumber = CAST(V.GUID  AS VARCHAR(50))
												AND GRVB.ProgramId = V.ProgramId
			WHERE SessionId =@SessionId;
			
			DELETE FROM VoucherImpTemp WHERE SessionId =@SessionId ;
			DELETE FROM EXT_GR_VoucherInfo_Buffer WHERE SessionId =@SessionId ;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
			ROLLBACK TRANSACTION;
	END CATCH		

END
