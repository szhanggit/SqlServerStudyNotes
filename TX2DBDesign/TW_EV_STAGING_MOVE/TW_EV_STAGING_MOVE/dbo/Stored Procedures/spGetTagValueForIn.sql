CREATE PROCEDURE dbo.spGetTagValueForIn @OrderLineId INT = NULL, @BeneficiaryInfoId BIGINT = NULL, @VoucherId BIGINT = NULL
AS
BEGIN
    IF(@OrderLineId is not null)
	Begin
		SELECT 
			v.id,
			ext.GCID,
			v.VoucherNumber as TableVoucherNumber,
            IIF(p.PinCodeType > 0, v.PinCode, '') as TablePinCode,
			v.ExpiryDate as TableExpiryDate,
			ext.GCID as TableGCID,
			v.GUID as TableGUID,
			(CASE 
				WHEN p.ProductType = 1 THEN pb.FaceValue
				WHEN p.ProductType = 2 THEN IIF(p.ProductSubType = 4, obi.FaceValue, vb.FaceValue)
				ELSE 0 
			END)/100 AS TableFaceValue,
			(CASE 
				WHEN p.ProductType = 1 THEN pb.FaceValue
				WHEN p.ProductType = 2 THEN IIF(p.ProductSubType = 4, obi.FaceValue, vb.FaceValue)
				ELSE 0 
			END)/100 AS [FaceValue],
			obi.VoucherQuantity as VoucherQuantity,
			v.AuthCode as TableShortUrlAuthCode,
			ex.RCN,
			ex.Flex1,
			ex.Flex2,
			ex.Flex3,
			ex.Flex4,
			ex.Flex5
		FROM dbo.Voucher AS v
		LEFT JOIN dbo.EXT_INGCID AS ext ON ext.Id = v.ExtendId
		INNER JOIN dbo.OrderBeneficiaryInfo AS obi ON obi.Id = v.BeneficiaryInfoId
		INNER JOIN dbo.ProductVersion pv ON obi.ProductVersionId = pv.Id
		INNER JOIN dbo.Product as p ON p.Id = pv.ProductId
		LEFT JOIN dbo.ProductPricingValueBased vb ON vb.Id = pv.ProductPricingValueBasedId
		LEFT JOIN dbo.ProductPricingProductBased pb ON pb.Id = pv.ProductPricingProductBasedId
		LEFT JOIN dbo.EXT_IN_APIOrderInfo ex on ex.OrderBeneficiaryInfoId = obi.Id
		WHERE obi.OrderLineId = @OrderLineId

		RETURN
	End
	
    IF(@BeneficiaryInfoId is not null)
	Begin
		SELECT 
			v.id,
			ext.GCID,
			v.VoucherNumber as TableVoucherNumber,
            IIF(p.PinCodeType > 0, v.PinCode, '') as TablePinCode,
			v.ExpiryDate as TableExpiryDate,
			ext.GCID as TableGCID,
			v.GUID as TableGUID,
			(CASE 
				WHEN p.ProductType = 1 THEN pb.FaceValue
				WHEN p.ProductType = 2 THEN IIF(p.ProductSubType = 4, obi.FaceValue, vb.FaceValue)
				ELSE 0 
			END)/100 AS TableFaceValue,
			(CASE 
				WHEN p.ProductType = 1 THEN pb.FaceValue
				WHEN p.ProductType = 2 THEN IIF(p.ProductSubType = 4, obi.FaceValue, vb.FaceValue)
				ELSE 0 
			END)/100 AS [FaceValue],
			obi.VoucherQuantity as VoucherQuantity,
			v.AuthCode as TableShortUrlAuthCode,
			ex.RCN,
			ex.Flex1,
			ex.Flex2,
			ex.Flex3,
			ex.Flex4,
			ex.Flex5
		FROM dbo.Voucher AS v
		LEFT JOIN dbo.EXT_INGCID AS ext ON ext.Id = v.ExtendId
		INNER JOIN dbo.OrderBeneficiaryInfo AS obi ON obi.Id = v.BeneficiaryInfoId
		INNER JOIN dbo.ProductVersion pv ON obi.ProductVersionId = pv.Id
		INNER JOIN dbo.Product as p ON p.Id = pv.ProductId
		LEFT JOIN dbo.ProductPricingValueBased vb ON vb.Id = pv.ProductPricingValueBasedId
		LEFT JOIN dbo.ProductPricingProductBased pb ON pb.Id = pv.ProductPricingProductBasedId
		LEFT JOIN dbo.EXT_IN_APIOrderInfo ex on ex.OrderBeneficiaryInfoId = obi.Id
		WHERE obi.Id = @BeneficiaryInfoId

		RETURN
	End

    IF(@VoucherId is not null)
	Begin
		SELECT 
			v.id,
			ext.GCID,
			v.VoucherNumber as TableVoucherNumber,
            IIF(p.PinCodeType > 0, v.PinCode, '') as TablePinCode,
			v.ExpiryDate as TableExpiryDate,
			ext.GCID as TableGCID,
			v.GUID as TableGUID,
			(CASE 
				WHEN p.ProductType = 1 THEN pb.FaceValue
				WHEN p.ProductType = 2 THEN IIF(p.ProductSubType = 4, obi.FaceValue, vb.FaceValue)
				ELSE 0 
			END)/100 AS TableFaceValue,
			(CASE 
				WHEN p.ProductType = 1 THEN pb.FaceValue
				WHEN p.ProductType = 2 THEN IIF(p.ProductSubType = 4, obi.FaceValue, vb.FaceValue)
				ELSE 0 
			END)/100 AS [FaceValue],
			obi.VoucherQuantity as VoucherQuantity,
			v.AuthCode as TableShortUrlAuthCode,
			ex.RCN,
			ex.Flex1,
			ex.Flex2,
			ex.Flex3,
			ex.Flex4,
			ex.Flex5
		FROM dbo.Voucher AS v
		LEFT JOIN dbo.EXT_INGCID AS ext ON ext.Id = v.ExtendId
		INNER JOIN dbo.OrderBeneficiaryInfo AS obi ON obi.Id = v.BeneficiaryInfoId
		INNER JOIN dbo.ProductVersion pv ON obi.ProductVersionId = pv.Id
		INNER JOIN dbo.Product as p ON p.Id = pv.ProductId
		LEFT JOIN dbo.ProductPricingValueBased vb ON vb.Id = pv.ProductPricingValueBasedId
		LEFT JOIN dbo.ProductPricingProductBased pb ON pb.Id = pv.ProductPricingProductBasedId
		LEFT JOIN dbo.EXT_IN_APIOrderInfo ex on ex.OrderBeneficiaryInfoId = obi.Id
		WHERE v.Id = @VoucherId

		RETURN
	End
END
