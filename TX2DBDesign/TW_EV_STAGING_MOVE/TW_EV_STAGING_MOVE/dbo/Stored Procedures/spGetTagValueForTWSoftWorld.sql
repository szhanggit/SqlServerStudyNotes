-- =============================================
-- Author:		<Author,Eagles>
-- Create date: <Create Date,2017-5-12>
-- Description:	<Description,GetTagValue For TWSoftWorld>
-- =============================================

CREATE PROCEDURE [dbo].[spGetTagValueForTWSoftWorld]
	@OrderLineId INT = null,
	@BeneficiaryInfoId BIGINT =null,
	@VoucherId BIGINT = null
AS
BEGIN
    IF(@OrderLineId is not null)
	Begin
		SELECT 
			v.id as id,
			sw.Barcode1 as Barcode1,
			sw.Barcode2 as Barcode2,
			CASE WHEN sw.TrustStartDate IS NULL THEN ''
				ELSE REPLACE(CONVERT(varchar(100), sw.TrustStartDate, 120),'-','/') END AS TrustStartDate,
			CASE WHEN sw.TrustEndDate IS NULL THEN ''
				ELSE REPLACE(CONVERT(varchar(100), sw.TrustEndDate, 120),'-','/') END AS TrustEndDate,
			p.ProductCode as Itemsku,
			obfi.ClientOrderNumber as ClientOrderNumber,
			obfi.Name as RecipientName
		FROM Voucher v
		INNER JOIN OrderBeneficiaryInfo obfi 
		ON v.BeneficiaryInfoId = obfi.Id
		INNER JOIN OrderLine ol
		ON obfi.OrderLineId = ol.Id
		INNER JOIN EXT_TW_SoftWorld sw
		ON v.ExtendId = sw.Id
		INNER JOIN Product p 
		ON v.ProductId = p.Id
		WHERE ol.Id = @OrderLineId

		Return
	End

    IF(@BeneficiaryInfoId is not null)
	Begin
		SELECT 
			v.id as id,
			sw.Barcode1 as Barcode1,
			sw.Barcode2 as Barcode2,
			CASE WHEN sw.TrustStartDate IS NULL THEN ''
				ELSE REPLACE(CONVERT(varchar(100), sw.TrustStartDate, 120),'-','/') END AS TrustStartDate,
			CASE WHEN sw.TrustEndDate IS NULL THEN ''
				ELSE REPLACE(CONVERT(varchar(100), sw.TrustEndDate, 120),'-','/') END AS TrustEndDate,
			p.ProductCode as Itemsku,
			obfi.ClientOrderNumber as ClientOrderNumber,
			obfi.Name as RecipientName
		FROM Voucher v
		INNER JOIN OrderBeneficiaryInfo obfi 
		ON v.BeneficiaryInfoId = obfi.Id
		INNER JOIN OrderLine ol
		ON obfi.OrderLineId = ol.Id
		INNER JOIN EXT_TW_SoftWorld sw
		ON v.ExtendId = sw.Id
		INNER JOIN Product p 
		ON v.ProductId = p.Id
		WHERE obfi.Id = @BeneficiaryInfoId

		Return
	End

    IF(@VoucherId is not null)
	Begin
		SELECT 
			v.id as id,
			sw.Barcode1 as Barcode1,
			sw.Barcode2 as Barcode2,
			CASE WHEN sw.TrustStartDate IS NULL THEN ''
				ELSE REPLACE(CONVERT(varchar(100), sw.TrustStartDate, 120),'-','/') END AS TrustStartDate,
			CASE WHEN sw.TrustEndDate IS NULL THEN ''
				ELSE REPLACE(CONVERT(varchar(100), sw.TrustEndDate, 120),'-','/') END AS TrustEndDate,
			p.ProductCode as Itemsku,
			obfi.ClientOrderNumber as ClientOrderNumber,
			obfi.Name as RecipientName
		FROM Voucher v
		INNER JOIN OrderBeneficiaryInfo obfi 
		ON v.BeneficiaryInfoId = obfi.Id
		INNER JOIN OrderLine ol
		ON obfi.OrderLineId = ol.Id
		INNER JOIN EXT_TW_SoftWorld sw
		ON v.ExtendId = sw.Id
		INNER JOIN Product p 
		ON v.ProductId = p.Id
		WHERE v.Id = @VoucherId

		Return
	End

END
