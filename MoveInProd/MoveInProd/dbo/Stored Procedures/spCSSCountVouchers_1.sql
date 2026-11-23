
CREATE PROCEDURE [dbo].[spCSSCountVouchers] 
	@VoucherNumber VARCHAR(50) = NULL
	,@ClientOrderNo VARCHAR(50) = NULL
	,@Email VARCHAR(100) = NULL
	,@Mobile VARCHAR(50) = NULL
	,@ShortUrl VARCHAR(20) = NULL
	,@GUID VARCHAR(50) = NULL
	,@ActiveDate datetime = NULL
	,@VoucherStatus int = NULL
	,@CSUserId INT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @CSUserRole INT
	DECLARE @SQLText NVARCHAR(MAX)
	--CSUserRole=1:Normal
	--CSUserRole=2:Admin
	SELECT @CSUserRole=CSUserRole FROM CSUser WHERE Id = @CSUserId

	IF @CSUserRole = 1
	BEGIN
		Set @SQLText = 
		'SELECT COUNT(1) AS TotalCount
		FROM Voucher v WITH(NOLOCK)
			INNER JOIN OrderBeneficiaryInfo obi WITH(NOLOCK) ON v.BeneficiaryInfoId = obi.Id
			INNER JOIN OrderLine ol WITH(NOLOCK) ON obi.OrderLineId = ol.Id
			INNER JOIN [Order] o WITH(NOLOCK) ON ol.OrderId = o.Id
			INNER JOIN Product p WITH(NOLOCK) ON v.ProductId = p.Id
			INNER JOIN ClientQuotation cq WITH(NOLOCK) ON o.ClientQuotationId = cq.Id
			INNER JOIN Client c WITH(NOLOCK) ON cq.ClientId = c.Id
			INNER JOIN CSUserClient CC WITH(NOLOCK) ON C.Id = CC.ClientId
			INNER JOIN CSUser CSU WITH(NOLOCK) ON CC.CSUserId = CSU.Id
			LEFT JOIN CSUserClientQuotation CCQ WITH(NOLOCK) ON CCQ.CSUserId = CSU.Id
			LEFT JOIN VoucherShortUrl vsu WITH(NOLOCK) ON v.Id = vsu.Id
		WHERE '

		set @SQLText = @SQLText + ' CSU.Id = ' + cast(@CSUserId as varchar(20))

		if @VoucherNumber is not null
			set @SQLText = @SQLText + ' and v.VoucherNumber = '''+ @VoucherNumber + ''''
            
		if @ClientOrderNo is not null
            set @SQLText = @SQLText + ' and obi.ClientOrderNumber = ''' + @ClientOrderNo + ''''

        if @Email is not null
            set @SQLText = @SQLText + ' and obi.Email = ''' + @Email + ''''

        if @Mobile is not null
            set @SQLText = @SQLText + ' and obi.Mobile = ''' + @Mobile +  ''''
		
		if @ShortUrl is not null
			set @SQLText = @SQLText + ' and vsu.VoucherAlias = ''' + @ShortUrl +  ''''

		if @GUID is not null
			set @SQLText = @SQLText + ' and v.[GUID] = ''' + @GUID +  ''''

		set @SQLText = @SQLText +        
            ' and ((CCQ.ID IS NULL) OR (CCQ.ID IS NOT NULL AND CCQ.QuotationId = CQ.Id)) '

		exec (@SQLText)
	END
	IF @CSUserRole = 2
	BEGIN
		Set @SQLText = 
		'SELECT COUNT(1) AS TotalCount
		FROM Voucher v WITH(NOLOCK)
			INNER JOIN OrderBeneficiaryInfo obi WITH(NOLOCK) ON v.BeneficiaryInfoId = obi.Id
			INNER JOIN OrderLine ol WITH(NOLOCK) ON obi.OrderLineId = ol.Id
			INNER JOIN [Order] o WITH(NOLOCK) ON ol.OrderId = o.Id
			INNER JOIN Product p WITH(NOLOCK) ON v.ProductId = p.Id
			INNER JOIN ClientQuotation cq WITH(NOLOCK) ON o.ClientQuotationId = cq.Id
			LEFT JOIN VoucherShortUrl vsu WITH(NOLOCK) ON v.Id = vsu.Id
		WHERE 1 = 1 '
		if @VoucherNumber is not null
			set @SQLText = @SQLText + ' and v.VoucherNumber = '''+ @VoucherNumber + ''''
            
		if @ClientOrderNo is not null
            set @SQLText = @SQLText + ' and obi.ClientOrderNumber = ''' + @ClientOrderNo + ''''

        if @Email is not null
            set @SQLText = @SQLText + ' and obi.Email = ''' + @Email + ''''

        if @Mobile is not null
            set @SQLText = @SQLText + ' and obi.Mobile = ''' + @Mobile +  ''''
		
		if @ShortUrl is not null
			set @SQLText = @SQLText + ' and vsu.VoucherAlias = ''' + @ShortUrl +  ''''

		if @GUID is not null
			set @SQLText = @SQLText + ' and v.[GUID] = ''' + @GUID +  ''''

		exec (@SQLText)
	END

	IF @CSUserRole = 3
	BEGIN
		Set @SQLText = 
		'SELECT COUNT(1) AS TotalCount
		FROM Voucher v WITH(NOLOCK)
			INNER JOIN OrderBeneficiaryInfo obi WITH(NOLOCK) ON v.BeneficiaryInfoId = obi.Id
			INNER JOIN OrderLine ol WITH(NOLOCK) ON obi.OrderLineId = ol.Id
			INNER JOIN [Order] o WITH(NOLOCK) ON ol.OrderId = o.Id
			INNER JOIN Product p WITH(NOLOCK) ON v.ProductId = p.Id
			INNER JOIN ClientQuotation cq WITH(NOLOCK) ON o.ClientQuotationId = cq.Id
			INNER JOIN Client c WITH (NOLOCK) ON cq.ClientId = c.Id
			LEFT JOIN VoucherShortUrl vsu WITH(NOLOCK) ON v.Id = vsu.Id
		WHERE 1 = 1 '
		if @VoucherNumber is not null
			set @SQLText = @SQLText + ' and v.VoucherNumber = '''+ @VoucherNumber + ''''
            
		if @ClientOrderNo is not null
            set @SQLText = @SQLText + ' and obi.ClientOrderNumber = ''' + @ClientOrderNo + ''''

        if @Email is not null
            set @SQLText = @SQLText + ' and obi.Email = ''' + @Email + ''''

        if @Mobile is not null
            set @SQLText = @SQLText + ' and obi.Mobile = ''' + @Mobile +  ''''
		
		if @ShortUrl is not null
			set @SQLText = @SQLText + ' and vsu.VoucherAlias = ''' + @ShortUrl +  ''''

		if @GUID is not null
			set @SQLText = @SQLText + ' and v.[GUID] = ''' + @GUID +  ''''

		if @ActiveDate is not null
			set @SQLText = @SQLText + ' and v.ActivatedOn >=''' + CONVERT(varchar(20),@ActiveDate,112) +  '''and v.ActivatedOn <''' + CONVERT(varchar(20),DATEADD(DAY,1,@ActiveDate),112) + ''''

		if @VoucherStatus is not null
			set @SQLText = @SQLText + ' and v.[Status] = ' + CONVERT(varchar(10),@VoucherStatus)

		exec (@SQLText)
	END
END
