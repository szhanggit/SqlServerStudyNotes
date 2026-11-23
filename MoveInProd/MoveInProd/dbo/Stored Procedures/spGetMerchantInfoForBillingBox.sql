-- =============================================
-- Author:		Zhu Jianhua
-- Create date: 2017-08-31
-- Description:	Get merchant info for billing box.
-- =============================================
CREATE PROCEDURE spGetMerchantInfoForBillingBox 
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
    
	SELECT T1.Id,
		T6.IdentityCode,
		T1.AddressId,
		T1.CategoryId,
		T1.IdentityCode,
		T1.Name,
		T1.[ExternalCode],
		T1.[InvoiceRegisterNumber],
		T1.[Status],
		T1.[Description],
		T1.Modifier,
		T1.[Version],
		REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR, ISNULL(T1.VersionTime,''), 120),'-',''),':',''),' ','') AS [VersionTime],
		T1.IsAutoCreateReimbursement,
		T1.AutoCreateReimbursementIntervalType,
		T1.AutoCreateReimbursementDay,
		T1.[ReimbursementTaxType],
		REPLACE(ISNULL(T1.[ReimbursementReceivers],''),';',','),
		T2.DetailAddressLine,
		T2.District,
		T2.CityId,
		T3.Name AS CityDisplayName,
		T2.StateOrProvinceId,
		T4.Name AS StateOrProvinceDisplayName,
		T2.Postcode,
		T2.CountryId,
		T4.Name AS CountryDisplayName,
		T1.MAMEmail,
		T1.ReimbursementType,
		T1.MerchantAutoType,
		T1.MerchantEmail
	FROM dbo.Merchant AS T1 
		LEFT JOIN dbo.[Address] T2 ON T1.AddressId = T2.Id
		LEFT JOIN dbo.Dictionary T3 ON T2.CityId = T3.Id
		LEFT JOIN dbo.Dictionary T4 ON T2.StateOrProvinceId = T4.Id
		LEFT JOIN dbo.Dictionary T5 ON T2.CountryId = T5.Id
		LEFT JOIN [dbo].[Program] T6 ON T1.ProgramId = T6.Id
	WHERE T1.VersionTime >= @BeginDate AND T1.VersionTime < @EndDate
		AND T1.[Status] = 1

END
