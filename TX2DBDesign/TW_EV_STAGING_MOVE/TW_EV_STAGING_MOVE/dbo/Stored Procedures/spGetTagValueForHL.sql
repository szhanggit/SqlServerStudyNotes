
CREATE PROCEDURE [dbo].[spGetTagValueForHL]
	@OrderLineId INT = null,
	@BeneficiaryInfoId BIGINT = null,
	@VoucherId BIGINT = null
AS
BEGIN
	IF (@OrderLineId IS NOT NULL)
	BEGIN
		SELECT
			A.Id,
			D.Barcode1,
			D.Barcode2,
			D.Barcode3,
			D.Barcode4
		FROM Voucher A
		INNER JOIN OrderBeneficiaryInfo B
			ON A.BeneficiaryInfoId = B.Id
		INNER JOIN OrderLine C
			ON B.OrderLineId = C.Id
		INNER JOIN VoucherExtendCode D
			ON A.Id = D.Id
		WHERE C.Id = @OrderLineId
		
		RETURN
	END
	
	IF (@BeneficiaryInfoId IS NOT NULL)
	BEGIN
		SELECT
			A.Id,
			C.Barcode1,
			C.Barcode2,
			C.Barcode3,
			C.Barcode4
		FROM Voucher A
		INNER JOIN OrderBeneficiaryInfo B
			ON A.BeneficiaryInfoId = B.Id
		INNER JOIN VoucherExtendCode C
			ON A.Id = C.Id
		WHERE B.Id = @BeneficiaryInfoId
		
		RETURN
	END
	
	IF (@VoucherId IS NOT NULL)
	BEGIN
		SELECT
			A.Id,
			B.Barcode1,
			B.Barcode2,
			B.Barcode3,
			B.Barcode4
		FROM Voucher A
		INNER JOIN VoucherExtendCode B
			ON A.Id = B.Id
		WHERE A.Id = @VoucherId
		
		RETURN
	END
END
