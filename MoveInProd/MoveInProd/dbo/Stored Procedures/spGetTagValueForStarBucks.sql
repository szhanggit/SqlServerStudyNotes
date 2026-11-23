

-- =============================================
-- Author:		<Author,Eagles>
-- Create date: <Create Date,2017-6-7>
-- Description:	<Description,GetTagValue For StarBucks>
-- =============================================

CREATE PROCEDURE [dbo].[spGetTagValueForStarBucks]
	@OrderLineId INT = null,
	@BeneficiaryInfoId BIGINT =null,
	@VoucherId BIGINT = null
AS
BEGIN
    IF(@OrderLineId is not null)
	Begin
		SELECT 
			v.id as id,
			sb.AuthCode as AuthCode,
			sb.DownloadURL as DownloadURL,
			sb.ExpiryDate as ExpiryDate,
			sb.QRCode as QRCode
		FROM Voucher v
		INNER JOIN OrderBeneficiaryInfo obfi 
		ON v.BeneficiaryInfoId = obfi.Id
		INNER JOIN OrderLine ol
		ON obfi.OrderLineId = ol.Id
		INNER JOIN EXT_TW_Starbucks sb
		ON v.ExtendId = sb.Id
		WHERE ol.Id = @OrderLineId
		Return
	End

    IF(@BeneficiaryInfoId is not null)
	Begin
		SELECT 
			v.id as id,
			sb.AuthCode as AuthCode,
			sb.DownloadURL as DownloadURL,
			sb.ExpiryDate as ExpiryDate,
			sb.QRCode as QRCode
		FROM Voucher v
		INNER JOIN OrderBeneficiaryInfo obfi 
		ON v.BeneficiaryInfoId = obfi.Id
		INNER JOIN OrderLine ol
		ON obfi.OrderLineId = ol.Id
		INNER JOIN EXT_TW_Starbucks sb
		ON v.ExtendId = sb.Id
		WHERE obfi.Id = @BeneficiaryInfoId

		Return
	End

    IF(@VoucherId is not null)
	Begin
		SELECT 
			v.id as id,
			sb.AuthCode as AuthCode,
			sb.DownloadURL as DownloadURL,
			sb.ExpiryDate as ExpiryDate,
			sb.QRCode as QRCode
		FROM Voucher v
		INNER JOIN OrderBeneficiaryInfo obfi 
		ON v.BeneficiaryInfoId = obfi.Id
		INNER JOIN OrderLine ol
		ON obfi.OrderLineId = ol.Id
		INNER JOIN EXT_TW_Starbucks sb
		ON v.ExtendId = sb.Id
		WHERE v.Id = @VoucherId

		Return
	End

END
