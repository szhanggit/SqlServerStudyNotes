-- =============================================
-- Author:		<Author,Eagles>
-- Create date: <Create Date,2017-5-12>
-- Description:	<Description,GetTagValue For GR>
-- =============================================

CREATE PROCEDURE [dbo].[spGetTagValueForFM]
	@OrderLineId INT = null,
	@BeneficiaryInfoId BIGINT =null,
	@VoucherId BIGINT = null
AS
BEGIN
    IF(@OrderLineId is not null)
	Begin
		SELECT 
			v.id as id,
			FM.Barcode1 as Barcode1,
			FM.Barcode2 as Barcode2,
			FM.Barcode3 as Barcode3,
			FM.Barcode4 as Barcode4
		FROM Voucher v
		INNER JOIN OrderBeneficiaryInfo obfi 
		ON v.BeneficiaryInfoId = obfi.Id
		INNER JOIN OrderLine ol
		ON obfi.OrderLineId = ol.Id
		INNER JOIN EXT_TW_FamilyMart AS FM
		ON v.ExtendId = FM.Id
		WHERE ol.Id = @OrderLineId

		Return
	End
	
    IF(@BeneficiaryInfoId is not null)
	Begin
		SELECT 
			v.id as id,
			FM.Barcode1 as Barcode1,
			FM.Barcode2 as Barcode2,
			FM.Barcode3 as Barcode3,
			FM.Barcode4 as Barcode4
		FROM Voucher v
		INNER JOIN OrderBeneficiaryInfo obfi 
		ON v.BeneficiaryInfoId = obfi.Id
		INNER JOIN OrderLine ol
		ON obfi.OrderLineId = ol.Id
		INNER JOIN EXT_TW_FamilyMart AS FM
		ON v.ExtendId = FM.Id
		WHERE obfi.Id = @BeneficiaryInfoId

		Return
	End

    IF(@VoucherId is not null)
	Begin
		SELECT 
			v.id as id,
			FM.Barcode1 as Barcode1,
			FM.Barcode2 as Barcode2,
			FM.Barcode3 as Barcode3,
			FM.Barcode4 as Barcode4
		FROM Voucher v
		INNER JOIN OrderBeneficiaryInfo obfi 
		ON v.BeneficiaryInfoId = obfi.Id
		INNER JOIN OrderLine ol
		ON obfi.OrderLineId = ol.Id
		INNER JOIN EXT_TW_FamilyMart AS FM
		ON v.ExtendId = FM.Id
		WHERE v.Id = @VoucherId

		Return
	End

END
