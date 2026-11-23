
CREATE PROCEDURE [dbo].[spGetInstantCashDenominationReport] 
	@SettlementDay INT -- NowDate - 1
	,@TrustBank NVARCHAR(500)
	,@BatchNo VARCHAR(50)
	,@Brand VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
		Brand
		,TrustAccountBatchNo AS BatchNo
		,TrustAccountBank AS TrustBank
		,GuaranteedAmount AS GuaranteedQuantity
	FROM [dbo].[EXT_TW_TrustAccountReport]
	WHERE ReportType = 3
	AND ReportDate <= @SettlementDay
	AND (ISNULL(@BatchNo,'')='' OR [TrustAccountBatchNo] LIKE '%'+@BatchNo+'%')
	AND (ISNULL(@TrustBank,'')='' OR TrustAccountBank LIKE N'%'+@TrustBank+'%')
	AND (ISNULL(@Brand,'')='' OR Brand LIKE '%'+@Brand+'%')
END
