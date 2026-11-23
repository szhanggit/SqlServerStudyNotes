
CREATE PROCEDURE [dbo].[spGetReimbursementDetailById]
    @ReimbursementId BIGINT ,
    @ReimbursementTaxType TINYINT
AS
    BEGIN
        SET NOCOUNT ON;

        IF @ReimbursementTaxType = 3
            BEGIN 
                SELECT  p.ProductName ,			
						p.ProductCode,		
						p.ExternalProductCode,
						p.ProductType,	
                        SUM(CASE WHEN rs.value < 0
                                 THEN ISNULL(rd.TransactionCount, 0) * -1
                                 ELSE ISNULL(rd.TransactionCount, 0)
                            END) AS TransactionCount ,
                        ABS(rs.Value) AS ReimbursementValue ,
                        CAST(ISNULL(ISNULL(pppb.FaceValue, ppvb.FaceValue), 0)
                        / 100.00 AS NUMERIC(15, 4)) AS FaceValue
                FROM    ReimbursementDetail AS rd WITH ( NOLOCK )
                        INNER JOIN ReimbursementScheme AS rs WITH ( NOLOCK ) ON rd.ReimbursementSchemeId = rs.Id
                        INNER JOIN ClientQuotationProduct AS cqp WITH ( NOLOCK ) ON rd.ClientQuotationProductId = cqp.Id
                        INNER JOIN ProductVersion AS pv WITH ( NOLOCK ) ON cqp.ProductVersionId = pv.Id
                        INNER JOIN dbo.Product AS p WITH ( NOLOCK ) ON pv.ProductId = p.Id
                        LEFT JOIN ProductPricingProductBased AS pppb WITH ( NOLOCK ) ON pv.ProductPricingProductBasedId = pppb.Id
                        LEFT JOIN ProductPricingValueBased AS ppvb WITH ( NOLOCK ) ON pv.ProductPricingValueBasedId = ppvb.Id
                WHERE   rd.ReimbursementId = @ReimbursementId
                        AND rs.Value != 0
                GROUP BY p.ProductName ,
						p.ProductCode,
						p.ExternalProductCode,
						p.ProductType,
                        ABS(rs.Value) ,
                        pppb.FaceValue ,
                        ppvb.FaceValue
            END
        ELSE
            BEGIN 
                SELECT  p.ProductName ,	
						p.ProductCode,		
						p.ExternalProductCode,
						p.ProductType,	
                        SUM(CASE WHEN rs.value < 0
                                 THEN ISNULL(rd.TransactionCount, 0) * -1
                                 ELSE ISNULL(rd.TransactionCount, 0)
                            END) AS TransactionCount ,
                        ABS(rs.Value) AS ReimbursementValue
                FROM    dbo.ReimbursementDetail AS rd WITH ( NOLOCK )
                        INNER JOIN ReimbursementScheme AS rs WITH ( NOLOCK ) ON rd.ReimbursementSchemeId = rs.Id
                        INNER JOIN ClientQuotationProduct AS cqp WITH ( NOLOCK ) ON rd.ClientQuotationProductId = cqp.Id
                        INNER JOIN ProductVersion AS pv WITH ( NOLOCK ) ON cqp.ProductVersionId = pv.Id
                        INNER JOIN dbo.Product AS p WITH ( NOLOCK ) ON pv.ProductId = p.Id
                WHERE   rd.ReimbursementId = @ReimbursementId
                        AND rs.Value != 0
                GROUP BY p.ProductName ,
						p.ProductCode,
						p.ExternalProductCode,
						p.ProductType,
                        ABS(rs.Value)
            END
       
    END
