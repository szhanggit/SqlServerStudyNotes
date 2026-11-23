
CREATE PROCEDURE spGetTagValueForSG
	-- Add the parameters for the stored procedure here
	@OrderLineId INT = null,
	@BeneficiaryInfoId BIGINT =null,
	@VoucherId BIGINT = null
AS
BEGIN
    IF(@OrderLineId is not null)
	Begin
		SELECT 
			T1.id AS id,
			T4.VerificationNumber AS VerificationNumber
		FROM Voucher AS T1
		INNER JOIN OrderBeneficiaryInfo AS T2 ON T1.BeneficiaryInfoId = T2.Id
		INNER JOIN OrderLine AS T3 ON T2.OrderLineId = T3.Id
		INNER JOIN EXT_SG_SerialNumber AS T4 ON T1.ExtendId = T4.Id
		WHERE T3.Id = @OrderLineId

		Return
	End
	
    IF(@BeneficiaryInfoId is not null)
	Begin
		SELECT 
			T1.id AS id,
			T4.VerificationNumber AS VerificationNumber
		FROM Voucher AS T1
		INNER JOIN OrderBeneficiaryInfo AS T2 ON T1.BeneficiaryInfoId = T2.Id
		INNER JOIN OrderLine AS T3 ON T2.OrderLineId = T3.Id
		INNER JOIN EXT_SG_SerialNumber AS T4 ON T1.ExtendId = T4.Id
		WHERE T2.Id = @BeneficiaryInfoId

		Return
	End

    IF(@VoucherId is not null)
	Begin
		SELECT 
			T1.id AS id,
			T4.VerificationNumber AS VerificationNumber
		FROM Voucher AS T1
		INNER JOIN OrderBeneficiaryInfo AS T2 ON T1.BeneficiaryInfoId = T2.Id
		INNER JOIN OrderLine AS T3 ON T2.OrderLineId = T3.Id
		INNER JOIN EXT_SG_SerialNumber AS T4 ON T1.ExtendId = T4.Id
		WHERE T1.Id = @VoucherId

		Return
	End

END
