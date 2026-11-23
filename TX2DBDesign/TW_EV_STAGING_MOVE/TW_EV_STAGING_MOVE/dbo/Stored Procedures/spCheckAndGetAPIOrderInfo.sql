
CREATE PROCEDURE [dbo].[spCheckAndGetAPIOrderInfo]
    @OrderNumber VARCHAR(50) ,
    @ProductCode VARCHAR(50) ,
    @ConsumerCode VARCHAR(50) ,
    @RequestQuanity INT ,
    @SoldPrice NUMERIC(15, 4) = NULL ,   --used by GetMultiVouchers
    @SoldPriceWithTax NUMERIC(15, 4) = NULL ,
    @ResponseCode VARCHAR(10) OUTPUT ,
    @IsIgnoreIssueNumberLimit BIT OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;
        SET @ResponseCode = '0000'
        DECLARE @ClientQuotationProductId INT
        DECLARE @MaxIssueLimit INT
        DECLARE @IssuedQuantity INT	
        DECLARE @ProductType TINYINT
        DECLARE @CurrentDateTime DATETIME = GETDATE()

        IF ( @SoldPrice IS NULL AND @SoldPriceWithTax IS NULL)
            BEGIN 
                SELECT  @ClientQuotationProductId = cqp.Id ,
                        @MaxIssueLimit = ISNULL(cqp.MaxIssueVoucherNumber, 0) ,
                        @IsIgnoreIssueNumberLimit = cq.IsIgnoreIssueNumberLimit
                FROM    [Order] o WITH ( NOLOCK )
                        JOIN OrderLine ol WITH ( NOLOCK ) ON ol.OrderId = o.Id
                        JOIN ClientQuotationProduct cqp WITH ( NOLOCK ) ON ol.ClientQuotationProductId = cqp.Id
                        JOIN ProductVersion pv WITH ( NOLOCK ) ON cqp.ProductVersionId = pv.Id
                        JOIN Product p WITH ( NOLOCK ) ON pv.ProductId = p.Id
                        JOIN ClientQuotation cq WITH ( NOLOCK ) ON cqp.ClientQuotationId = cq.Id
                        JOIN Client c WITH ( NOLOCK ) ON cq.ClientId = c.Id
                        LEFT JOIN ClearCacheProductStopAPI ccp WITH(NOLOCK) ON ccp.ProductId = p.Id AND ccp.Status = 0 AND ccp.ValidEnd>GETDATE()
                        LEFT JOIN PreIssuedCampaignOrderInfo pic WITH(NOLOCK) ON pic.OrderNumber = o.OrderNumber AND pic.ProductCode= p.ProductCode
                WHERE   o.OrderNumber = @OrderNumber
                        AND p.ProductCode = @ProductCode
                        AND ( ISNULL(@ConsumerCode, '') = ''
                              OR c.IdentityCode = @ConsumerCode
                            )
                        AND o.Status = 64
                        AND o.Mode = 2
                        AND p.Status = 1
                        AND ol.Status = 1
                        AND ( p.CanIssue = 1
                              OR p.StopIssueTime > GETDATE()
                            )
                        And (ccp.Id IS NULL OR pic.OrderNumber IS NOT NULL)
            END
        ELSE
            BEGIN 
                SELECT  @ProductType = ProductType
                FROM    dbo.Product WITH ( NOLOCK )
                WHERE   ProductCode = @ProductCode
                IF ( ISNULL(@ProductType, 0) = 0 )
                    BEGIN
                        SET @ResponseCode = 'MA0002'
                        RETURN
                    END

                IF @ProductType = 1
                    BEGIN 
                        SELECT  @ClientQuotationProductId = cqp.Id ,
                                @MaxIssueLimit = ISNULL(cqp.MaxIssueVoucherNumber,
                                                        0) ,
                                @IsIgnoreIssueNumberLimit = cq.IsIgnoreIssueNumberLimit,
                                @SoldPrice = cqpsp.SoldPriceWithoutTax * pppb.Balance,
                                @SoldPriceWithTax = cqpsp.SoldPriceWithTax * pppb.Balance
                        FROM    [Order] o WITH ( NOLOCK )
                                JOIN OrderLine ol WITH ( NOLOCK ) ON ol.OrderId = o.Id
                                JOIN ClientQuotationProduct cqp WITH ( NOLOCK ) ON ol.ClientQuotationProductId = cqp.Id
                                JOIN ClientQuotationProductSoldPrice cqpsp WITH ( NOLOCK ) ON cqp.Id = cqpsp.ClientQuotationProductId
                                JOIN ProductVersion pv WITH ( NOLOCK ) ON cqp.ProductVersionId = pv.Id
                                JOIN Product p WITH ( NOLOCK ) ON pv.ProductId = p.Id
                                JOIN ClientQuotation cq WITH ( NOLOCK ) ON cqp.ClientQuotationId = cq.Id
                                JOIN Client c WITH ( NOLOCK ) ON cq.ClientId = c.Id
                                JOIN dbo.ProductPricingProductBased pppb WITH(NOLOCK) ON pppb.Id = pv.ProductPricingProductBasedId
                                LEFT JOIN ClearCacheProductStopAPI ccp WITH(NOLOCK) ON ccp.ProductId = p.Id AND ccp.Status = 0 AND ccp.ValidEnd>GETDATE()
                                LEFT JOIN PreIssuedCampaignOrderInfo pic WITH(NOLOCK) ON pic.OrderNumber = o.OrderNumber AND pic.ProductCode= p.ProductCode
                        WHERE   o.OrderNumber = @OrderNumber
                                AND p.ProductCode = @ProductCode
                                AND ( ISNULL(@ConsumerCode, '') = ''
                                      OR c.IdentityCode = @ConsumerCode
                                    )
                                AND (cqpsp.SoldPriceWithoutTax * pppb.Balance = @SoldPrice OR cqpsp.SoldPriceWithTax * pppb.Balance = @SoldPriceWithTax)
                                AND cqpsp.ValidityFrom <= @CurrentDateTime
                                AND cqpsp.ValidityEnd >= @CurrentDateTime
                                AND cqpsp.Status = 2
                                AND o.Status = 64
                                AND o.Mode = 2
                                AND p.Status = 1
                                AND ol.Status = 1
                                AND ( p.CanIssue = 1
                                      OR p.StopIssueTime > GETDATE()
                                    )
                                And (ccp.Id IS NULL OR pic.OrderNumber IS NOT NULL)
                    END

                IF @ProductType = 2
                    BEGIN 

                        SELECT  @ClientQuotationProductId = cqp.Id ,
                                @MaxIssueLimit = ISNULL(cqp.MaxIssueVoucherNumber,
                                                        0) ,
                                @IsIgnoreIssueNumberLimit = cq.IsIgnoreIssueNumberLimit,
                                @SoldPrice = cqpsp.ValueBasedSoldPriceWithoutTax,
                                @SoldPriceWithTax = cqpsp.ValueBasedSoldPriceWithTax
                        FROM    [Order] o WITH ( NOLOCK )
                                JOIN OrderLine ol WITH ( NOLOCK ) ON ol.OrderId = o.Id
                                JOIN ClientQuotationProduct cqp WITH ( NOLOCK ) ON ol.ClientQuotationProductId = cqp.Id
                                JOIN ClientQuotationProductSoldPrice cqpsp WITH ( NOLOCK ) ON cqp.Id = cqpsp.ClientQuotationProductId
                                JOIN ProductVersion pv WITH ( NOLOCK ) ON cqp.ProductVersionId = pv.Id
                                JOIN Product p WITH ( NOLOCK ) ON pv.ProductId = p.Id
                                JOIN ClientQuotation cq WITH ( NOLOCK ) ON cqp.ClientQuotationId = cq.Id
                                JOIN Client c WITH ( NOLOCK ) ON cq.ClientId = c.Id
                                LEFT JOIN ClearCacheProductStopAPI ccp WITH(NOLOCK) ON ccp.ProductId = p.Id AND ccp.Status = 0 AND ccp.ValidEnd>GETDATE()
                                LEFT JOIN PreIssuedCampaignOrderInfo pic WITH(NOLOCK) ON pic.OrderNumber = o.OrderNumber AND pic.ProductCode= p.ProductCode
                        WHERE   o.OrderNumber = @OrderNumber
                                AND p.ProductCode = @ProductCode
                                AND ( ISNULL(@ConsumerCode, '') = ''
                                      OR c.IdentityCode = @ConsumerCode
                                    )
                                AND (cqpsp.ValueBasedSoldPriceWithoutTax = @SoldPrice OR cqpsp.ValueBasedSoldPriceWithTax = @SoldPriceWithTax)
                                AND cqpsp.ValidityFrom <= @CurrentDateTime
                                AND cqpsp.ValidityEnd >= @CurrentDateTime
                                AND cqpsp.Status = 2
                                AND o.Status = 64
                                AND o.Mode = 2
                                AND p.Status = 1
                                AND ol.Status = 1
                                AND ( p.CanIssue = 1
                                      OR p.StopIssueTime > GETDATE()
                                    )
                                And (ccp.Id IS NULL OR pic.OrderNumber IS NOT NULL)
                    END
            END

        IF ( ISNULL(@ClientQuotationProductId, 0) = 0 )
            BEGIN
                SET @ResponseCode = 'MA0002'
                RETURN
            END

	  --check quantity
        IF ( @IsIgnoreIssueNumberLimit = 0
             AND @MaxIssueLimit > 0
           )
            BEGIN 
                SELECT  @IssuedQuantity = SUM(ISNULL(ol.TotalQuantity, 0))
                FROM    OrderLine ol WITH ( NOLOCK )
                        JOIN [Order] o WITH ( NOLOCK ) ON ol.OrderId = o.Id
                        JOIN ClientQuotationProduct cqp WITH ( NOLOCK ) ON ol.ClientQuotationProductId = cqp.Id
                WHERE   o.Status = 64
                        AND cqp.Id = @ClientQuotationProductId
      
                IF ( @MaxIssueLimit > 0
                     AND ISNULL(@IssuedQuantity, 0) + @RequestQuanity > @MaxIssueLimit
                   )
                    BEGIN
                        SET @ResponseCode = 'MA0020'
                        RETURN
                    END
            END 

        SELECT  ISNULL(olep.Type, ep.Type)  AS ExpirationPolicyType ,
                ISNULL(olep.Id, ep.Id)  AS ExpirySchemeId ,
                pv1.id AS CurrentProductVersionId ,
                ol.DefaultExpirationDate AS DefaultExpirationDate ,
                ISNULL(c.NeedNotification, 0) AS NeedNotification ,
                d.Name AS NotificationProviderCode ,
                pg.IdentityCode AS ProgramCode ,
                ol.Id AS OrderLineId ,
                ol.NeedShortUrl ,
                p.CanIssue ,
                p.StopIssueTime,
                p.ProductCode,
                p.VoucherSupplierId,
                p.ProductType,
				p.ProductSubType,
                IIF(p.ProductIssuerType = 0, cq.FinanceExpireDays, NULL) FinanceExpireDays,
                p.VoucherNumberGenerateWay,
                @SoldPrice AS SoldPrice,
                @SoldPriceWithTax AS SoldPriceWithTax,
                o.ShortUrlAuthCodeGenerationWay,
                CASE
                    WHEN p.ProductType = 1 THEN pppb.FaceValueWithTax
                    WHEN p.ProductType = 2 THEN IIF(p.ProductSubType = 4, NULL, ppvb.FaceValueWithTax)
                    ELSE NULL
                END FaceValueWithTax,
                ISNULL(pppb.Balance, 1) Balance
        FROM    [Order] o WITH ( NOLOCK )
                JOIN OrderLine ol WITH ( NOLOCK ) ON ol.OrderId = o.Id
                JOIN ClientQuotationProduct cqp WITH ( NOLOCK ) ON ol.ClientQuotationProductId = cqp.Id
                JOIN ProductVersion pv WITH ( NOLOCK ) ON cqp.ProductVersionId = pv.Id
                JOIN Product p WITH ( NOLOCK ) ON pv.ProductId = p.Id
                JOIN Program pg WITH ( NOLOCK ) ON p.ProgramId = pg.Id
                JOIN ClientQuotation cq WITH ( NOLOCK ) ON cqp.ClientQuotationId = cq.Id
                JOIN Client c WITH ( NOLOCK ) ON cq.ClientId = c.Id
                LEFT JOIN Dictionary d WITH ( NOLOCK ) ON c.NotificationProviderCodeId = d.Id
                JOIN ExpirationPolicy ep WITH ( NOLOCK ) ON cqp.ExpirySchemeId = ep.Id
                JOIN ProductVersion pv1 WITH ( NOLOCK ) ON p.Id = pv1.ProductId
                LEFT JOIN dbo.ExpirationPolicy AS olep WITH(NOLOCK) ON olep.Id = ol.ExpirationPolicyId
                LEFT JOIN dbo.ProductPricingProductBased pppb WITH(NOLOCK) ON pppb.Id = pv.ProductPricingProductBasedId
                LEFT JOIN dbo.ProductPricingValueBased ppvb WITH(NOLOCK) ON ppvb.Id = pv.ProductPricingValueBasedId
        WHERE   o.OrderNumber = @OrderNumber
                AND p.ProductCode = @ProductCode
                AND ( ISNULL(@ConsumerCode, '') = ''
                      OR c.IdentityCode = @ConsumerCode
                    )
                AND o.Status = 64
                AND o.Mode = 2
                AND p.Status = 1
                AND ol.Status = 1
                AND pv1.IsCurrentVersion = 1
                AND ( p.CanIssue = 1
                      OR p.StopIssueTime > GETDATE()
                    )
    END
