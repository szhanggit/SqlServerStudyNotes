-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spVoucherInfoV2]
	-- Add the parameters for the stored procedure here
	@MerchantIdentityCode varchar(50), 
	@StartDate varchar(20), 
	@EndDate varchar(20)
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
;
WITH TransData
AS
(SELECT
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
	   ,ExternalOrderId
	   ,ExternalProductCode
	   ,AccountGUID
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
	INNER JOIN Product WITH (NOLOCK)
		ON Account.ProductId = Product.Id
	WHERE Merchant.IdentityCode = @MerchantIdentityCode
	AND DATEADD(hh, 8, Account.LastTranOn) BETWEEN @StartDate AND @EndDate
	AND [Transaction].TranLocalDateTime BETWEEN @StartDate AND @EndDate)

SELECT
	voucher_no
   ,expired_date
   ,VoucherStatus
   ,MerchantCode
   ,ProgramCode
   ,action_type
   ,result_type
   ,action_date
   ,ExternalProductCode product_code
   ,[Order].IsDirectDelivery
FROM TransData
JOIN TW_EV_UAT_MOVE.dbo.[Order] WITH (NOLOCK)
	ON ExternalOrderId = OrderNumber
JOIN TW_EV_UAT_MOVE.dbo.Voucher WITH (NOLOCK)
	ON AccountGUID = TW_EV_UAT_MOVE.dbo.Voucher.GUID
JOIN TW_EV_UAT_MOVE.dbo.VoucherReservationBatch WITH (NOLOCK)
	ON ReservationBatchId = TW_EV_UAT_MOVE.dbo.VoucherReservationBatch.Id
JOIN TW_EV_UAT_MOVE.dbo.VoucherReservationCode WITH (NOLOCK)
	ON VoucherReservationBatch.VoucherReservationCodeId = VoucherReservationCode.Id
END