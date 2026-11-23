-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spGetReimbursementMaking 
	-- Add the parameters for the stored procedure here
	@StartDate  int ,
	@EndDate  int ,
	@MerchantId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 0 AS [No] 
		,P.ProductName AS Product
		, M.Name AS Merchant
		, C.Name AS Client
		, T.AccountNumber AS VoucherNumber
		, CONVERT(VARCHAR(100), V.PublishedOn, 120) AS DeliveryDateTime
		, T.ReimbursementValue AS ReimbursementAmount
		,CASE WHEN p.ProductType = 1
            THEN 0
            ELSE --t.TranAmount*1.0000/105
				CASE WHEN t.TranType = 201 
					THEN -t.TranAmount*1.0000/105
                ELSE t.TranAmount*1.0000/105
            END
        END AS TransactionAmount
		, 'Success' AS ResultType
		, CONVERT(VARCHAR, T.TranType) AS ProcessType
		, T.TranAmount AS Quantity
		, CONVERT(VARCHAR(100), T.TranLocalDateTime, 120) AS TransactionDate
		, T.TranCode AS TransactionCode
		, S.Name AS Shop 
		, T.SettleDate 
		, P.ProductCode AS ProductCode
		, P.ExternalProductCode AS ExternalProductCode
		, T.TerminalSSN AS TerminalSSN
		, P.ProductType AS ProductType
	FROM    dbo.[Transaction] AS T WITH ( NOLOCK )
		INNER JOIN ReimbursementLine AS RL WITH ( NOLOCK ) ON t.ReimbursementLineId = rl.Id
		INNER JOIN dbo.Product AS P WITH ( NOLOCK ) ON t.ProductId = p.Id
		INNER JOIN dbo.Merchant AS M WITH ( NOLOCK ) ON t.MerchantId = m.Id
		INNER JOIN [dbo].[Voucher] AS V WITH ( NOLOCK ) ON t.AccountNumber = V.VoucherNumber
		INNER JOIN dbo.[Order] AS O WITH ( NOLOCK ) ON t.OrderId = o.Id
		INNER JOIN dbo.ClientQuotation AS CQ WITH ( NOLOCK ) ON o.ClientQuotationId = cq.Id
		INNER JOIN dbo.Client AS C WITH ( NOLOCK ) ON cq.ClientId = c.Id
		LEFT JOIN dbo.Shop AS S WITH ( NOLOCK ) ON t.ShopId = s.Id
	WHERE RL.SettleDate >=  @StartDate
		AND RL.SettleDate <=  @EndDate		
		AND T.ReimbursementValue != 0		
		AND T.ResponseCode = '0000'
		AND (((@MerchantId IS NULL) AND 1=1) OR(@MerchantId IS NOT NULL) AND T.MerchantId = @MerchantId)
END
