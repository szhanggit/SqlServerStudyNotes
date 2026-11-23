-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetClientInfoForBillingBox] 
	-- Add the parameters for the stored procedure here
	@DATETIME DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @BeginDate DATETIME
	DECLARE @EndDate DATETIME

	SET @BeginDate = DATEADD(D,DATEDIFF(D,0,@DATETIME),0)
	SET @EndDate = DATEADD(DAY,1,@BeginDate)
    
	SELECT t1.Id,
		t1.Name,
		t1.AddressId,
		t1.[Version],
		REPLACE(REPLACE(REPLACE(CONVERT(varchar, ISNULL(t1.VersionTime,''), 120),'-',''),':',''),' ','') AS [VersionTime],
		t2.DetailAddressLine,
		t2.District,
		t2.CityId,
		t3.Name AS [CityName],
		t2.StateOrProvinceId,
		t4.Name AS [StateName],
		t2.Postcode,
		t2.CountryId,
		t5.Name AS [CountryName],
		t1.[Status],
		t1.Title,
		t1.IdentityCode,
		t1.InvoiceRegisterNumber
	FROM dbo.Client t1 
		LEFT JOIN dbo.[Address] t2 ON t1.AddressId = t2.Id
		LEFT JOIN dbo.Dictionary t3 ON t2.CityId = t3.Id
		LEFT JOIN dbo.Dictionary t4 ON t2.StateOrProvinceId = t4.Id
		LEFT JOIN dbo.Dictionary t5 ON t2.CountryId = t5.Id
	--WHERE t1.VersionTime >= @BeginDate AND t1.VersionTime < @EndDate
	--	AND t1.[Status] = 1

END
