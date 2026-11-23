
CREATE PROCEDURE [dbo].[spGetOrderGroupUploadTemplate]
	@SessionId VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

	SELECT a.ProductCode, p.ProductName, ep.Id ExpirationPolicyId, d.DisplayName ExpirationPolicyDesciption
	INTO #TEMP
	FROM UploadProductBuffer a
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
	WHERE a.SessionId = @SessionId
	ORDER BY a.ProductCode, ep.Id

	DELETE UploadProductBuffer WHERE SessionId = @SessionId

	SELECT * FROM #TEMP
	DROP TABLE #TEMP
END
