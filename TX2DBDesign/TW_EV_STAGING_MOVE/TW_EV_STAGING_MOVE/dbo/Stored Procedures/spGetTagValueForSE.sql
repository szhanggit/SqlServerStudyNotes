-- =============================================
-- Author:		<Author,Eagles>
-- Create date: <Create Date,2017-5-12>
-- Description:	<Description,GetTagValue For GR>
-- =============================================

CREATE PROCEDURE [dbo].[spGetTagValueForSE]
	@OrderLineId INT = null,
	@BeneficiaryInfoId BIGINT =null,
	@VoucherId BIGINT = null
AS
BEGIN
    IF(@OrderLineId is not null)
	Begin
		SELECT 
			v.id as id,
			SE.Barcode1 as Barcode1,
			SE.Barcode2 as Barcode2,
			CASE WHEN SE.TrustStartDate IS NULL THEN ''
				ELSE REPLACE(CONVERT(varchar(100), SE.TrustStartDate, 120),'-','/') END AS TrustStartDate,
			CASE WHEN SE.TrustEndDate IS NULL THEN ''
				ELSE REPLACE(CONVERT(varchar(100), SE.TrustEndDate, 120),'-','/') END AS TrustEndDate
		FROM Voucher v with(nolock)
		INNER JOIN OrderBeneficiaryInfo obfi with(nolock)
		ON v.BeneficiaryInfoId = obfi.Id
		INNER JOIN OrderLine ol with(nolock)
		ON obfi.OrderLineId = ol.Id
		INNER JOIN EXT_TW_SEBarcode AS SE with(nolock)
		ON v.ExtendId = SE.Id
		WHERE ol.Id = @OrderLineId

		Return
	End
	
    IF(@BeneficiaryInfoId is not null)
	Begin
		SELECT 
			v.id as id,
			SE.Barcode1 as Barcode1,
			SE.Barcode2 as Barcode2,
			CASE WHEN SE.TrustStartDate IS NULL THEN ''
				ELSE REPLACE(CONVERT(varchar(100), SE.TrustStartDate, 120),'-','/') END AS TrustStartDate,
			CASE WHEN SE.TrustEndDate IS NULL THEN ''
				ELSE REPLACE(CONVERT(varchar(100), SE.TrustEndDate, 120),'-','/') END AS TrustEndDate
		FROM Voucher v with(nolock)
		INNER JOIN OrderBeneficiaryInfo obfi with(nolock)
		ON v.BeneficiaryInfoId = obfi.Id
		INNER JOIN OrderLine ol with(nolock)
		ON obfi.OrderLineId = ol.Id
		INNER JOIN EXT_TW_SEBarcode AS SE with(nolock)
		ON v.ExtendId = SE.Id
		WHERE obfi.Id = @BeneficiaryInfoId

		Return
	End

    IF(@VoucherId is not null)
	Begin
		SELECT 
			v.id as id,
			SE.Barcode1 as Barcode1,
			SE.Barcode2 as Barcode2,
			CASE WHEN SE.TrustStartDate IS NULL THEN ''
				ELSE REPLACE(CONVERT(varchar(100), SE.TrustStartDate, 120),'-','/') END AS TrustStartDate,
			CASE WHEN SE.TrustEndDate IS NULL THEN ''
				ELSE REPLACE(CONVERT(varchar(100), SE.TrustEndDate, 120),'-','/') END AS TrustEndDate
		FROM Voucher v with(nolock)
		INNER JOIN OrderBeneficiaryInfo obfi with(nolock)
		ON v.BeneficiaryInfoId = obfi.Id
		INNER JOIN OrderLine ol with(nolock)
		ON obfi.OrderLineId = ol.Id
		INNER JOIN EXT_TW_SEBarcode AS SE with(nolock)
		ON v.ExtendId = SE.Id
		WHERE v.Id = @VoucherId

		Return
	End

END
