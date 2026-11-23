

CREATE PROCEDURE [dbo].[spGetMerchantReportDetailItems]
    @ConsumeMerchantCode VARCHAR(50) ,
    @ConsumeShopCode VARCHAR(50) = NULL ,
    @ProductCode VARCHAR(50) ,
    @StartConsumeTime DATETIME ,
    @EndConsumeTime DATETIME
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT  pm.IdentityCode AS Programcode ,
                v.VoucherNumber ,
                p.ProductCode ,
                p.ProductName ,
                v.ConsumeTime ,
                v.ConsumeTerminalSSN ,
                s.Name AS ShopName ,
                CAST(ISNULL(ISNULL(pppb.FaceValue, ppvb.FaceValue), 0)
                / 100.00 AS NUMERIC(15, 2)) AS FaceValue
        FROM    dbo.Voucher AS v WITH ( NOLOCK )
                INNER JOIN dbo.Product AS p WITH ( NOLOCK ) ON p.Id = v.ProductId
                INNER JOIN dbo.Program AS pm ON pm.Id = v.ProgramId
                INNER JOIN dbo.OrderBeneficiaryInfo AS obi WITH ( NOLOCK ) ON obi.Id = v.BeneficiaryInfoId
                INNER JOIN dbo.ProductVersion AS pv WITH ( NOLOCK ) ON pv.Id = obi.ProductVersionId
                LEFT JOIN dbo.ProductPricingProductBased AS pppb WITH ( NOLOCK ) ON pppb.Id = pv.ProductPricingProductBasedId
                LEFT JOIN dbo.ProductPricingValueBased AS ppvb WITH ( NOLOCK ) ON ppvb.Id = pv.ProductPricingValueBasedId
                LEFT JOIN dbo.Shop AS s WITH ( NOLOCK ) ON v.ConsumeShopCode = s.IdentityCode
        WHERE   v.ConsumeMerchantCode = @ConsumeMerchantCode
                AND ( v.ConsumeShopCode = @ConsumeShopCode
                      OR @ConsumeShopCode IS NULL
                    )
                AND v.ConsumeTime >= @StartConsumeTime
                AND v.ConsumeTime <= @EndConsumeTime
                AND p.ProductCode = @ProductCode
                AND v.[Status] = 32
    END

