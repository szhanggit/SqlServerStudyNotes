
CREATE PROCEDURE [dbo].[spGetQuotationGrandTotalInfo]
    @QuotationNumber VARCHAR(50) ,
    @ProductCode VARCHAR(50)
AS
    BEGIN

        SELECT  ISNULL((case p.ProductType when 1 then cqpsp.SoldPriceWithTax when 2 then cqpsp.ValueBasedSoldPriceWithTax end),0) AS SoldPrice ,
                cqpsftt.SoldPriceWithTax AS FeeWithTax ,
				sfd.Name AS ServiceFeeName
        FROM    dbo.ClientQuotation AS cq
                INNER JOIN dbo.ClientQuotationProduct AS cqp ON cqp.ClientQuotationId = cq.Id
				INNER JOIN [dbo].[ClientQuotationProductSoldPrice] AS CQPSP ON cqp.Id = CQPSP.ClientQuotationProductId
                LEFT JOIN dbo.ClientQuotationProductServiceFeeTriggerTime AS cqpsftt WITH ( NOLOCK ) ON cqpsftt.ClientQuotationProductId = cqp.Id
                LEFT JOIN dbo.ServiceFeeTriggerTime AS sftt WITH ( NOLOCK ) ON sftt.Id = cqpsftt.ServiceFeeTriggerTimeId
                                                              AND sftt.TranType = 401
                LEFT JOIN dbo.ServiceFee AS sf WITH ( NOLOCK ) ON sf.Id = sftt.ServiceFeeId
                LEFT JOIN dbo.Dictionary AS sfd WITH ( NOLOCK ) ON sfd.Id = sf.ServiceFeeNameId
                INNER JOIN dbo.ProductVersion AS pv WITH ( NOLOCK ) ON pv.Id = cqp.ProductVersionId
                INNER JOIN dbo.Product AS p ON p.Id = pv.ProductId
        WHERE   cq.QuotationNumber = @QuotationNumber
                AND p.ProductCode = @ProductCode
    END
	
		
