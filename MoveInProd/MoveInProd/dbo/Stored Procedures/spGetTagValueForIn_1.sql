

CREATE PROCEDURE dbo.spGetTagValueForIn
    @OrderLineId INT = NULL, @BeneficiaryInfoId BIGINT = NULL, @VoucherId BIGINT = NULL
AS  
BEGIN
    IF(@OrderLineId is not null)
	Begin
		SELECT 
			v.id,
			ext.GCID,
			v.VoucherNumber as TableVoucherNumber,
			v.PinCode as TablePinCode,
			v.ExpiryDate as TableExpiryDate,
			ext.GCID as TableGCID,
			v.GUID as TableGUID,
			(CASE WHEN p.ProductType =1 THEN pb.FaceValue ELSE IIF(p.ProductSubType=2,vb.FaceValue,obi.FaceValue) END)/100 as TableFaceValue,			
			v.ShortUrl as TableShortURL,
			v.AuthCode as TableShortUrlAuthCode,
			aoi.RCN,
			aoi.Flex1,
			aoi.Flex2,
			aoi.Flex3,
			aoi.Flex4,
			aoi.Flex5
		FROM dbo.Voucher AS v
		LEFT JOIN dbo.EXT_INGCID AS ext ON ext.Id = v.ExtendId
		INNER JOIN dbo.OrderBeneficiaryInfo AS obi ON obi.Id = v.BeneficiaryInfoId
		INNER JOIN dbo.ProductVersion pv ON obi.ProductVersionId = pv.Id
		INNER JOIN dbo.Product as p ON p.Id = pv.ProductId
		LEFT JOIN dbo.ProductPricingValueBased vb ON vb.Id = pv.ProductPricingValueBasedId
		LEFT JOIN dbo.ProductPricingProductBased pb ON pb.Id = pv.ProductPricingProductBasedId
		LEFT JOIN dbo.EXT_IN_APIOrderInfo aoi ON aoi.OrderBeneficiaryInfoId  = obi.Id
		WHERE obi.OrderLineId = @OrderLineId

		RETURN
	End
	
    IF(@BeneficiaryInfoId is not null)
	Begin
		SELECT 
			v.id,
			ext.GCID,
			v.VoucherNumber as TableVoucherNumber,
			v.PinCode as TablePinCode,
			v.ExpiryDate as TableExpiryDate,
			ext.GCID as TableGCID,
			v.GUID as TableGUID,
			(CASE WHEN p.ProductType =1 THEN pb.FaceValue ELSE IIF(p.ProductSubType=2,vb.FaceValue,obi.FaceValue) END)/100 as TableFaceValue,
			v.ShortUrl as TableShortURL,
			v.AuthCode as TableShortUrlAuthCode,
			aoi.RCN,
			aoi.Flex1,
			aoi.Flex2,
			aoi.Flex3,
			aoi.Flex4,
			aoi.Flex5
		FROM dbo.Voucher AS v
		LEFT JOIN dbo.EXT_INGCID AS ext ON ext.Id = v.ExtendId
		INNER JOIN dbo.OrderBeneficiaryInfo AS obi ON obi.Id = v.BeneficiaryInfoId
		INNER JOIN dbo.ProductVersion pv ON obi.ProductVersionId = pv.Id
		INNER JOIN dbo.Product as p ON p.Id = pv.ProductId
		LEFT JOIN dbo.ProductPricingValueBased vb ON vb.Id = pv.ProductPricingValueBasedId
		LEFT JOIN dbo.ProductPricingProductBased pb ON pb.Id = pv.ProductPricingProductBasedId
		LEFT JOIN dbo.EXT_IN_APIOrderInfo aoi ON aoi.OrderBeneficiaryInfoId  = obi.Id
		WHERE obi.Id = @BeneficiaryInfoId

		RETURN
	End

    IF(@VoucherId is not null)
	Begin
		SELECT 
			v.id,
			ext.GCID,
			v.VoucherNumber as TableVoucherNumber,
			v.PinCode as TablePinCode,
			v.ExpiryDate as TableExpiryDate,
			ext.GCID as TableGCID,
			v.GUID as TableGUID,
			(CASE WHEN p.ProductType =1 THEN pb.FaceValue ELSE IIF(p.ProductSubType=2,vb.FaceValue,obi.FaceValue) END)/100 as TableFaceValue,
			v.ShortUrl as TableShortURL,
			v.AuthCode as TableShortUrlAuthCode,
			aoi.RCN,
			aoi.Flex1,
			aoi.Flex2,
			aoi.Flex3,
			aoi.Flex4,
			aoi.Flex5
		FROM dbo.Voucher AS v
		LEFT JOIN dbo.EXT_INGCID AS ext ON ext.Id = v.ExtendId
		INNER JOIN dbo.OrderBeneficiaryInfo AS obi ON obi.Id = v.BeneficiaryInfoId
		INNER JOIN dbo.ProductVersion pv ON obi.ProductVersionId = pv.Id
		INNER JOIN dbo.Product as p ON p.Id = pv.ProductId
		LEFT JOIN dbo.ProductPricingValueBased vb ON vb.Id = pv.ProductPricingValueBasedId
		LEFT JOIN dbo.ProductPricingProductBased pb ON pb.Id = pv.ProductPricingProductBasedId
		LEFT JOIN dbo.EXT_IN_APIOrderInfo aoi ON aoi.OrderBeneficiaryInfoId  = obi.Id		
		WHERE v.Id = @VoucherId

		RETURN
	End
END
