-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spGetQuotationInfoForBillingBox
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

	SELECT t1.Id AS [ClientQuotationId],
		t2.Id AS [ClientId],	
		t1.QuotationNumber,
		t1.ProjectCode,
		t1.ProjectName,
		t3.Id AS [BusinessModelId],
		t4.Name AS [BusinessModelDisplayName],
		T1.BusinessTypeId AS [BusinessTypeId],
		t5.Name AS [BusinessTypeDisplayName],
		t1.AutoCreateBilling,
		t1.BBXAdvanceBilling,
		t1.FinanceEmail,
		t1.BillingFrequency,
		t1.BillingDate,
		t1.PaymentTerm,
		t1.Sales, 
		REPLACE(REPLACE(REPLACE(CONVERT(varchar, ISNULL(t1.ModifiedOn,''), 120),'-',''),':',''),' ','') AS [ModifiedOn],
		t1.SalesEmail,
		T1.SubBusinessModelId,
		T1.[ContactName],
		T1.[ContactEmail],
		T1.[ContactPhone],
		t1.EndClientId,
		t1.IsAutoCreateFapaio
	FROM dbo.ClientQuotation t1 
		JOIN dbo.Client t2 ON t1.ClientId = t2.Id
		JOIN dbo.BusinessModel t3 ON t1.BusinessModelId = t3.Id
		JOIN dbo.Dictionary t4 ON t3.DisplayNameId = t4.Id
		LEFT JOIN dbo.Dictionary t5 ON t1.BusinessTypeId = t5.Id
	--WHERE T1.ModifiedOn >= @BeginDate AND T1.ModifiedOn < @EndDate

END

