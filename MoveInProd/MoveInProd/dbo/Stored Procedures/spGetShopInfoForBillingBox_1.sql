-- =============================================
-- Author:		Zhu Jianhua
-- Create date: 2017-08-31
-- Description:	Get shop info for billing box.
-- =============================================
CREATE PROCEDURE spGetShopInfoForBillingBox 
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
		T1.MerchantId,
		T1.IdentityCode,
		T1.ExternalCode,
		T1.Name,
		T1.AddressId,
		REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR, ISNULL(T1.CreatedOn,''), 120),'-',''),':',''),' ','') AS CreatedOn,
		REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR, ISNULL(T1.LastModifiedOn,''), 120),'-',''),':',''),' ','') AS LastModifiedOn,
		T1.LastModifier,
		T1.[Status]
	FROM dbo.Shop AS T1 
	WHERE T1.[LastModifiedOn] >= @BeginDate AND T1.[LastModifiedOn] < @EndDate
		AND T1.[Status] = 1

END
