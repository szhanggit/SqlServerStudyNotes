

CREATE PROCEDURE [dbo].[spQueryTransactionHistoryByShop]
    @MerchantCode VARCHAR(50) ,
    @StartDate DATETIME ,
    @EndDate DATETIME ,
    @AccountNumber VARCHAR(50)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT  t1.TranCode ,
                t1.TranType ,
                t1.TranLocalDateTime ,
                t1.TranRealDateTime ,
                t3.TimeOffset ,
                t2.ProductType ,
                t1.TranAmount ,
                t1.ResponseCode ,
                t1.MerchantCode ,
                t4.Name AS MerchantName ,
                t1.ShopCode ,
                t5.Name AS ShopName
        FROM    dbo.[Transaction] AS t1 WITH ( NOLOCK )
                JOIN dbo.Product AS t2 WITH ( NOLOCK ) ON t2.Id = t1.ProductId
                JOIN dbo.Program AS t3 WITH ( NOLOCK ) ON t3.Id = t2.ProgramId
                LEFT JOIN dbo.Merchant AS t4 WITH ( NOLOCK ) ON t4.Id = t1.MerchantId
                LEFT JOIN dbo.Shop AS t5 WITH ( NOLOCK ) ON t5.Id = t1.ShopId
        WHERE   t1.AccountNumber = @AccountNumber
                AND t1.TranRealDateTime >= @StartDate
                AND t1.TranRealDateTime <= @EndDate
                AND t1.MerchantCode = @MerchantCode


    END

