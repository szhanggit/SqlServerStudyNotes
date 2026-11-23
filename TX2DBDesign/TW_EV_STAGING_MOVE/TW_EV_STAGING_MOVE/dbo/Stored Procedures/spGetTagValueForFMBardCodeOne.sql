
CREATE PROCEDURE [dbo].[spGetTagValueForFMBardCodeOne]
	@OrderLineId INT = null,
	@BeneficiaryInfoId BIGINT =null,
	@VoucherId BIGINT = null
AS
BEGIN
    IF(@OrderLineId is not null)
	Begin
		SELECT 
			T1.id AS id,
			T4.Bardcode1
		FROM Voucher AS T1 with(nolock)
		INNER JOIN OrderBeneficiaryInfo AS T2 with(nolock) ON T1.BeneficiaryInfoId = T2.Id
		INNER JOIN OrderLine AS T3 with(nolock) ON T2.OrderLineId = T3.Id
		INNER JOIN EXT_TW_FamilyMartBardCodeOne AS T4 with(nolock) ON T1.ExtendId = T4.Id
		WHERE T3.Id = @OrderLineId

		Return
	End
	
    IF(@BeneficiaryInfoId is not null)
	Begin
		SELECT 
			T1.id AS id,
			T4.Bardcode1
		FROM Voucher AS T1 with(nolock)
		INNER JOIN OrderBeneficiaryInfo AS T2 with(nolock) ON T1.BeneficiaryInfoId = T2.Id
		INNER JOIN OrderLine AS T3 with(nolock) ON T2.OrderLineId = T3.Id
		INNER JOIN EXT_TW_FamilyMartBardCodeOne AS T4 with(nolock) ON T1.ExtendId = T4.Id
		WHERE T2.Id = @BeneficiaryInfoId

		Return
	End

    IF(@VoucherId is not null)
	Begin
		SELECT 
			T1.id AS id,
			T4.Bardcode1
		FROM Voucher AS T1 with(nolock)
		INNER JOIN OrderBeneficiaryInfo AS T2 with(nolock) ON T1.BeneficiaryInfoId = T2.Id
		INNER JOIN OrderLine AS T3 with(nolock) ON T2.OrderLineId = T3.Id
		INNER JOIN EXT_TW_FamilyMartBardCodeOne AS T4 with(nolock) ON T1.ExtendId = T4.Id
		WHERE T1.Id = @VoucherId

		Return
	End

END
