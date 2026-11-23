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
	DECLARE @WhereText NVARCHAR(2000) = N' WHERE ';
	--CSUserRole=1:Normal
	--CSUserRole=2:Admin
	--CSUserRole=3:OutSource
	--CSUserRole=4:NormalWithTrash
	SELECT @CSUserRole=CSUserRole FROM CSUser WHERE Id = @CSUserId

	SET @SQLText = 'SELECT COUNT(1) AS TotalCount FROM Voucher v WITH(NOLOCK)'

	if @VoucherNumber IS NOT NULL
		SET @WhereText = @WhereText + ' and v.VoucherNumber = '''+ @VoucherNumber + '''' 
	IF @ShortUrl IS NOT NULL
		SET @WhereText = @WhereText + ' and v.ShortUrl = ''' + @ShortUrl +  ''''
	IF @GUID IS NOT NULL
		SET @WhereText = @WhereText + ' and v.[GUID] = ''' + @GUID +  ''''
	IF @ActiveDate IS NOT NULL
		SET @WhereText = @WhereText + ' and v.ActivatedOn >=''' + CONVERT(varchar(20),@ActiveDate,112) +  '''and v.ActivatedOn <''' + CONVERT(varchar(20),DATEADD(DAY,1,@ActiveDate),112) + ''''
	IF @VoucherStatus IS NOT NULL
		SET @WhereText = @WhereText + ' and v.[Status] = ' + CONVERT(varchar(10),@VoucherStatus)

	IF @Email IS NOT NULL OR @Mobile IS NOT NULL OR @ClientOrderNo IS NOT NULL OR @CSUserRole = 1 OR @CSUserRole = 4
		SET @SQLText = @SQLText + ' INNER JOIN OrderBeneficiaryInfo obi WITH(NOLOCK) ON v.BeneficiaryInfoId = obi.Id';

	IF @Email IS NOT NULL
        set @WhereText = @WhereText + ' and obi.Email = ''' + @Email + ''''

    if @Mobile IS NOT NULL
        set @WhereText = @WhereText + ' and obi.Mobile = ''' + @Mobile +  ''''

	if @ClientOrderNo IS NOT NULL
        set @WhereText = @WhereText + ' and obi.ClientOrderNumber = ''' + @ClientOrderNo + ''''

	IF @CSUserRole = 1 or @CSUserRole = 4
	BEGIN
		SET @SQLText = @SQLText + ' INNER JOIN OrderLine ol WITH(NOLOCK) ON obi.OrderLineId = ol.Id
									INNER JOIN [Order] o WITH(NOLOCK) ON ol.OrderId = o.Id
									INNER JOIN ClientQuotation cq WITH(NOLOCK) ON o.ClientQuotationId = cq.Id
                                    INNER JOIN Client c WITH(NOLOCK) ON cq.ClientId = c.Id
									LEFT JOIN dbo.OrderExtendInfo ext WITH(NOLOCK) ON ext.Id = o.Id AND ext.CPClientId > 0
									INNER JOIN dbo.CSUserClient CC WITH(NOLOCK) ON CC.ClientId = C.Id OR CC.ClientId = ext.CPClientId
									INNER JOIN CSUser CSU WITH(NOLOCK) ON CC.CSUserId = CSU.Id
									';

		SET @WhereText = @WhereText + ' and CSU.Id = ' + cast(@CSUserId as varchar(20))
	END

	DECLARE @index INT = CHARINDEX('and', @WhereText);
	SET @WhereText = STUFF(@WhereText, @index, 3, '')

	SET @SQLText = @SQLText + @WhereText;

	EXEC(@SQLText);
END