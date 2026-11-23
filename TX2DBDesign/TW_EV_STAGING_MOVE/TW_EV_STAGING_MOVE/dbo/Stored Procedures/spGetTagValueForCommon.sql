CREATE PROCEDURE [dbo].[spGetTagValueForCommon]
	@OrderLineId INT = null,
	@BeneficiaryInfoId BIGINT =null,
	@VoucherId BIGINT = null
AS
BEGIN
    IF(@OrderLineId is not null)
	Begin
		SELECT
			 v.Id
			,v.ActivatedOn AS ActiveDate
			,v.VoucherNumber
			,obfi.Name BeneficiaryName
			,obfi.ClientOrderNumber
			,p.ProductName
			,v.ShortUrl
			,v.AuthCode
			,obfi.ExpiryDate
			,obfi.FaceValueWithTax
			,e.[Type]
			,e.ValidPeriod
			,e.IsEndOfDay
			,v.PinCode
			,CASE WHEN e.IsEndOfDay = 1 THEN T1.DateFormatString ELSE T1.DateTimeFormatString END ProgramDateTimeFormatString
			,T1.ActiveDateFormatString
			,obfi.ActiveDate as OrderBeneficiaryInfoActiveDate
			,v.GUID
		FROM Voucher v with(nolock,forceseek) 
				INNER JOIN OrderBeneficiaryInfo obfi with(nolock,forceseek) ON v.BeneficiaryInfoId = obfi.Id
				INNER JOIN OrderLine ol with(nolock) ON obfi.OrderLineId = ol.Id
				INNER JOIN Product p with(nolock) ON v.ProductId = p.Id
				INNER JOIN ExpirationPolicy e with(nolock) ON e.Id = obfi.ExpirySchemeId
				LEFT JOIN [dbo].[Program] AS T1 with(nolock) ON v.ProgramId = t1.Id
		WHERE ol.Id = @OrderLineId

		Return
	End
	
    IF(@BeneficiaryInfoId is not null)
	Begin
		SELECT
			 v.Id
			,v.ActivatedOn AS ActiveDate
			,v.VoucherNumber
			,obfi.Name BeneficiaryName
			,obfi.ClientOrderNumber
			,p.ProductName
			,v.ShortUrl
			,v.AuthCode
			,obfi.ExpiryDate
			,obfi.FaceValueWithTax
			,e.[Type]
			,e.ValidPeriod
			,e.IsEndOfDay
			,v.PinCode
			,CASE WHEN e.IsEndOfDay = 1 THEN T1.DateFormatString ELSE T1.DateTimeFormatString END ProgramDateTimeFormatString
			,T1.ActiveDateFormatString
			,obfi.ActiveDate as OrderBeneficiaryInfoActiveDate
			,v.GUID
		FROM Voucher v with(nolock,forceseek) 
				INNER JOIN OrderBeneficiaryInfo obfi with(nolock,forceseek) ON v.BeneficiaryInfoId = obfi.Id
				INNER JOIN OrderLine ol with(nolock) ON obfi.OrderLineId = ol.Id
				INNER JOIN Product p with(nolock) ON v.ProductId = p.Id
				INNER JOIN ExpirationPolicy e with(nolock) ON e.Id = obfi.ExpirySchemeId
				LEFT JOIN [dbo].[Program] AS T1 with(nolock) ON v.ProgramId = t1.Id
		WHERE obfi.Id = @BeneficiaryInfoId

		Return
	End

    IF(@VoucherId is not null)
	Begin
		SELECT
			 v.Id
			,v.ActivatedOn AS ActiveDate
			,v.VoucherNumber
			,obfi.Name BeneficiaryName
			,obfi.ClientOrderNumber
			,p.ProductName
			,v.ShortUrl
			,v.AuthCode
			,obfi.ExpiryDate
			,obfi.FaceValueWithTax
			,e.[Type]
			,e.ValidPeriod
			,e.IsEndOfDay
			,v.PinCode
			,CASE WHEN e.IsEndOfDay = 1 THEN T1.DateFormatString ELSE T1.DateTimeFormatString END ProgramDateTimeFormatString
			,T1.ActiveDateFormatString
			,obfi.ActiveDate as OrderBeneficiaryInfoActiveDate
			,v.GUID
		FROM Voucher v with(nolock,forceseek) 
				INNER JOIN OrderBeneficiaryInfo obfi with(nolock,forceseek) ON v.BeneficiaryInfoId = obfi.Id
				INNER JOIN OrderLine ol with(nolock) ON obfi.OrderLineId = ol.Id
				INNER JOIN Product p with(nolock) ON v.ProductId = p.Id
				INNER JOIN ExpirationPolicy e with(nolock) ON e.Id = obfi.ExpirySchemeId
				LEFT JOIN [dbo].[Program] AS T1 with(nolock) ON v.ProgramId = t1.Id
		WHERE v.Id = @VoucherId

		Return
	End

END