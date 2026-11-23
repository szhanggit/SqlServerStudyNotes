
CREATE PROCEDURE [dbo].[spGetReimbursementTransactionById]
    @ReimbursementId BIGINT,
	@TestBusinessModelId INT
AS
    BEGIN
        SET NOCOUNT ON;

        	SELECT  0 AS [No] ,		
				p.ProductCode,
				p.ProductType,	
				p.ExternalProductCode,
                p.ProductName AS Product ,
                m.Name AS Merchant ,
                c.Name AS Client ,
                t.AccountNumber AS VoucherNumber ,
                CONVERT(VARCHAR(100), V.PublishedOn, 120) AS DeliveryDateTime ,
                'Success' AS ResultType ,
                CONVERT(VARCHAR, t.TranType) AS ProcessType ,
				CASE WHEN t.TranType = 201
                    THEN -1
                    ELSE t.TranAmount
                END AS Quantity ,
                CONVERT(VARCHAR(100), t.TranLocalDateTime, 120) AS TransactionDate ,
                t.TranCode AS TransactionCode ,
                s.Name AS Shop ,
				CASE WHEN p.ProductType = 1
                    THEN 0
                    ELSE --t.TranAmount*1.0000/105
						CASE WHEN t.TranType = 201 THEN -t.TranAmount*1.0000/105
							ELSE t.TranAmount*1.0000/105
							END
                END AS TransactionAmount ,
                t.ReimbursementValue AS ReimbursementAmount ,
                t.SettleDate ,
                CONVERT(VARCHAR, cq.BusinessModelId) AS BusinessModel ,
                t.Rsv1 AS Rsv1,
				t.TerminalSSN
        FROM    dbo.[Transaction] AS t WITH ( NOLOCK )
                INNER JOIN ReimbursementLine AS rl WITH ( NOLOCK ) ON t.ReimbursementLineId = rl.Id
                INNER JOIN dbo.Product AS p WITH ( NOLOCK ) ON t.ProductId = p.Id
                INNER JOIN dbo.Merchant AS m WITH ( NOLOCK ) ON t.MerchantId = m.Id
				INNER JOIN [Voucher] V WITH (NOLOCK) on T.AccountNumber=V.VoucherNumber
                INNER JOIN dbo.[Order] AS o WITH ( NOLOCK ) ON t.OrderId = o.Id
                INNER JOIN dbo.ClientQuotation AS cq WITH ( NOLOCK ) ON o.ClientQuotationId = cq.Id
                INNER JOIN dbo.Client AS c WITH ( NOLOCK ) ON cq.ClientId = c.Id
                LEFT JOIN dbo.Shop AS s WITH ( NOLOCK ) ON t.ShopId = s.Id
				JOIN Program PM WITH(NOLOCK) on T.ProgramCode = PM.IdentityCode AND V.ProgramId = PM.Id
        WHERE   rl.ReimbursementId = @ReimbursementId
                AND ReimbursementValue != 0
                AND t.ResponseCode = '0000'
				AND cq.BusinessModelId != @TestBusinessModelId
    END
