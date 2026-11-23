
CREATE PROCEDURE [dbo].[spValidateOrderGroup]
	@OrderCreateId VARCHAR(50)
AS
BEGIN
	CREATE TABLE #ErrorTable
	(
		[Error] VARCHAR(50),
		[Source] NVARCHAR(200)
	)

	-- Validation quotation is valid and approved
	INSERT INTO #ErrorTable
	SELECT 'InvalidQuotation', A.QuotationNumber
	FROM (SELECT DISTINCT QuotationNumber FROM OrderCreateBuffer WHERE OrderCreateId = @OrderCreateId) A
	LEFT OUTER JOIN ClientQuotation B
		ON A.QuotationNumber = B.QuotationNumber
	WHERE (B.Status IS NULL OR B.Status <> 32)

	-- Validate product is valid and active
	INSERT INTO #ErrorTable
	SELECT DISTINCT 'InvalidProduct', A.ProductCode
	FROM (SELECT DISTINCT ProductCode FROM OrderCreateBuffer WHERE OrderCreateId = @OrderCreateId) A
	LEFT OUTER JOIN Product B
		ON A.ProductCode = B.ProductCode
	WHERE (B.Status IS NULL OR B.Status <> 1)

	-- Return if validation fail
	IF EXISTS(SELECT 1 FROM #ErrorTable)
	BEGIN
		SELECT * FROM #ErrorTable
		DROP TABLE #ErrorTable
		RETURN
	END

	-- Prepare quotation product mapping lookup
	SELECT A.QuotationNumber, E.ProductCode
	INTO #QuotationProduct
	FROM (SELECT DISTINCT QuotationNumber FROM OrderCreateBuffer WHERE OrderCreateId = @OrderCreateId) A
	INNER JOIN ClientQuotation B
		ON A.QuotationNumber = B.QuotationNumber
	INNER JOIN ClientQuotationProduct C
		ON B.Id = C.ClientQuotationId
	INNER JOIN ProductVersion D
		ON D.Id = C.ProductVersionId
	INNER JOIN Product E
		ON E.Id = D.ProductId

	-- Validation quotation-product mapping
	INSERT INTO #ErrorTable
	SELECT DISTINCT 'QuotationProductMap', A.QuotationNumber + ', ' + A.ProductCode
	FROM (SELECT DISTINCT QuotationNumber, ProductCode FROM OrderCreateBuffer WHERE OrderCreateId = @OrderCreateId) A
	LEFT OUTER JOIN #QuotationProduct B
		ON A.QuotationNumber = B.QuotationNumber AND A.ProductCode = B.ProductCode
	WHERE B.QuotationNumber IS NULL

	DROP TABLE #QuotationProduct

	-- Return if validation fail
	IF EXISTS(SELECT 1 FROM #ErrorTable)
	BEGIN
		SELECT * FROM #ErrorTable
		DROP TABLE #ErrorTable
		RETURN
	END

	-- Prepare product expiry type mapping lookup
	SELECT a.ProductCode, ep.Id ExpirationPolicyId, d.DisplayName ExpirationPolicyDesciption
	INTO #ProductExpiration
	FROM (SELECT DISTINCT ProductCode FROM OrderCreateBuffer WHERE OrderCreateId = @OrderCreateId) a
	INNER JOIN Product p 
		ON a.ProductCode = p.ProductCode
	INNER JOIN ProductExpiryScheme pes 
		ON pes.Id = p.ProductExpirySchemeId
	INNER JOIN ProductExpirySchemeSet pess 
		ON pess.ProductExpirySchemeId = pes.Id
	INNER JOIN ExpirationPolicy ep 
		ON ep.Id = pess.ExpirationPolicyId
	INNER JOIN Dictionary d 
		ON d.Id = ep.DisplayNameId

	-- Validate product expiry type
	INSERT INTO #ErrorTable
	SELECT DISTINCT 'ProductExpiryDateType', A.ProductCode + CONVERT(VARCHAR, ExpiryDateType)
	FROM (SELECT DISTINCT ProductCode, ExpiryDateType FROM OrderCreateBuffer WHERE OrderCreateId = @OrderCreateId) A
	LEFT OUTER JOIN #ProductExpiration B
		ON A.ProductCode = B.ProductCode AND A.ExpiryDateType = B.ExpirationPolicyId
	WHERE B.ProductCode IS NULL

	-- Validate expiry date
	INSERT INTO #ErrorTable
	SELECT DISTINCT 'ProductExpiryDate', A.ProductCode
	FROM (SELECT DISTINCT ProductCode, ExpiryDateType, ExpiryDate FROM OrderCreateBuffer WHERE OrderCreateId = @OrderCreateId) A
	INNER JOIN #ProductExpiration B
		ON A.ProductCode = B.ProductCode AND A.ExpiryDateType = B.ExpirationPolicyId
	WHERE B.ExpirationPolicyDesciption IN ('FixEndOfDay', 'FixNotEndOfDay')
		AND A.ExpiryDate IS NULL

	-- Validate voucher reservation code
	INSERT INTO #ErrorTable
	SELECT 'InvalidReservationCode', A.ReservationCode
	FROM (SELECT DISTINCT ReservationCode FROM OrderCreateBuffer WHERE OrderCreateId = @OrderCreateId AND ISNULL(ReservationCode, '') <> '') A
	LEFT OUTER JOIN VoucherReservationCode B
		ON A.ReservationCode = B.ReservationCode
	WHERE B.ReservationCode IS NULL

	-- Return error table
	SELECT * FROM #ErrorTable
	DROP TABLE #ErrorTable
	DROP TABLE #ProductExpiration
END
