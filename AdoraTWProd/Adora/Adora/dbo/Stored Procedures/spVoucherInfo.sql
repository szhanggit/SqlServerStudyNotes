CREATE PROCEDURE [dbo].[spVoucherInfo]
	-- Add the parameters for the stored procedure here
	@MerchantIdentityCode varchar(50), 
	@StartDate varchar(20), 
	@EndDate varchar(20)
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

-- Insert statements for procedure here

SELECT
	Data.voucher_no
	,Data.expired_date
	,Data.VoucherStatus
	,Data.MerchantCode
	,Data.ProgramCode
	,Data.action_type
	,Data.result_type
	,Data.action_date
	,Product.ExternalProductCode AS 'product_code'
	,(CASE ProductType
		WHEN 1 THEN (SELECT
					CAST(ROUND(CAST(mo_ProductPricingProductBased.FaceValue AS DECIMAL) * 0.0105, 0) AS INT)
				FROM TW_EV_DBS_MOVE.dbo.ProductPricingProductBased mo_ProductPricingProductBased
				WHERE ProductPricingProductBasedId = mo_ProductPricingProductBased.Id)
		ELSE (SELECT
					CAST(ROUND(CAST(mo_ProductPricingValueBased.FaceValue AS DECIMAL) * 0.0105, 0) AS INT)
				FROM TW_EV_DBS_MOVE.dbo.ProductPricingValueBased mo_ProductPricingValueBased
				WHERE ProductPricingValueBasedId = mo_ProductPricingValueBased.Id)
	END)
	AS 'product_face_value'
	,Voucher.Id AS voucher_id
	,[Order].Mode
	,[Order].IsDirectDelivery
	,ReservationCode
FROM (SELECT
		Account.AccountNumber AS 'voucher_no'
		,DATEADD(HOUR, 8
		, Account.ActiveTo) AS 'expired_date'
		,Account.Status AS 'VoucherStatus'
		,TranType AS action_type
		,ResponseCode AS result_type
		,TranLocalDateTime AS action_date
		,Program.ExternalId AS ProgramMoveId
		,Merchant.IdentityCode AS MerchantCode
		,Program.IdentityCode AS ProgramCode
	FROM [Transaction] WITH (NOLOCK)
	INNER JOIN Program WITH (NOLOCK)
		ON [Transaction].ProgramCode = Program.IdentityCode
	INNER JOIN Account WITH (NOLOCK)
		ON [Transaction].AccountNumber = Account.AccountNumber
		AND Program.Id = ProgramId
	INNER JOIN dbo.AcceptanceLoop WITH (NOLOCK)
		ON AcceptanceLoopId = AcceptanceLoop.Id
	INNER JOIN dbo.AcceptanceLoopMerchant WITH (NOLOCK)
		ON AcceptanceLoop.Id = AcceptanceLoopMerchant.AcceptanceLoopId
	INNER JOIN Merchant WITH (NOLOCK)
		ON MerchantId = Merchant.Id
	WHERE Merchant.IdentityCode = @MerchantIdentityCode
	AND DATEADD(hh, 8, Account.LastTranOn) BETWEEN @StartDate AND @EndDate
	AND [Transaction].TranLocalDateTime BETWEEN @StartDate AND @EndDate) Data
INNER JOIN TW_EV_DBS_MOVE.dbo.Voucher WITH (NOLOCK)
	ON Data.ProgramMoveId = ProgramId
		AND Data.voucher_no = VoucherNumber
INNER JOIN TW_EV_DBS_MOVE.dbo.OrderBeneficiaryInfo WITH (NOLOCK)
	ON BeneficiaryInfoId = OrderBeneficiaryInfo.Id
INNER JOIN TW_EV_DBS_MOVE.dbo.OrderLine WITH (NOLOCK)
	ON OrderBeneficiaryInfo.OrderLineId = OrderLine.Id
INNER JOIN TW_EV_DBS_MOVE.dbo.[Order] WITH (NOLOCK)
	ON OrderLine.OrderId = [Order].Id
INNER JOIN TW_EV_DBS_MOVE.dbo.ProductVersion WITH (NOLOCK)
	ON ProductVersionId = ProductVersion.Id
INNER JOIN TW_EV_DBS_MOVE.dbo.Product WITH (NOLOCK)
	ON ProductVersion.ProductId = Product.Id
INNER JOIN TW_EV_DBS_MOVE.dbo.VoucherReservationCode WITH (NOLOCK)
	ON OrderLine.VoucherReservationCodeId = VoucherReservationCode.ID
END