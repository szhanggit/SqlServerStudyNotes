
CREATE PROCEDURE spGetMerchantReportDetailItems
    @ProgramCode VARCHAR(20) ,
    @MerchantCode VARCHAR(50) ,
    @ShopCode VARCHAR(50) ,
    @TranLocalStartDate INT ,
    @TranLocalEndDate INT ,
    @ProductExternalId VARCHAR(50)
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        WITH    Trans
                  AS ( SELECT   AccountNumber ,
                                TranType ,
                                TranAmount ,
                                TranLocalDateTime
                       FROM     dbo.TransactionHistory WITH ( NOLOCK )
                       WHERE    ProgramCode = @ProgramCode
                                AND MerchantCode = @MerchantCode
                                AND ( ShopCode = @ShopCode
                                      OR ISNULL(@ShopCode, '') = ''
                                    )
                                AND TranLocalDate >= @TranLocalStartDate
                                AND TranLocalDate <= @TranLocalEndDate
                                AND TranType IN ( 101, 201, 103, 203 )
                                AND ResponseCode = '0000'
                       UNION ALL
                       SELECT   AccountNumber ,
                                TranType ,
                                TranAmount ,
                                TranLocalDateTime
                       FROM     dbo.[Transaction] WITH ( NOLOCK )
                       WHERE    ProgramCode = @ProgramCode
                                AND MerchantCode = @MerchantCode
                                AND ( ShopCode = @ShopCode
                                      OR ISNULL(@ShopCode, '') = ''
                                    )
                                AND TranLocalDate >= @TranLocalStartDate
                                AND TranLocalDate <= @TranLocalEndDate
                                AND TranType IN ( 101, 201, 103, 203 )
                                AND ResponseCode = '0000'
                     )
            SELECT  t4.ExternalId AS ProductExternalId ,
                    t2.AccountNumber ,
                    t2.Status ,
                    t2.ValueType ,
                    t1.TranLocalDateTime ,
                    IIF(TranType = 101
                    OR TranType = 103, t1.TranAmount, t1.TranAmount * ( -1 )) AS TranAmout
            FROM    Trans AS t1
                    JOIN dbo.Account AS t2 WITH ( NOLOCK ) ON t2.AccountNumber = t1.AccountNumber
                    JOIN dbo.Program AS t3 WITH ( NOLOCK ) ON t3.IdentityCode = @ProgramCode
                                                              AND t2.ProgramId = t3.Id
                    JOIN dbo.Product AS t4 WITH ( NOLOCK ) ON t4.Id = t2.ProductId
            WHERE   t4.ExternalId = @ProductExternalId
            UNION
            SELECT  t4.ExternalId AS ProductExternalId ,
                    t2.AccountNumber ,
                    t2.Status ,
                    t2.ValueType ,
                    t1.TranLocalDateTime ,
                    IIF(TranType = 101
                    OR TranType = 103, t1.TranAmount, t1.TranAmount * ( -1 )) AS TranAmout
            FROM    Trans AS t1
                    JOIN dbo.AccountHistory AS t2 WITH ( NOLOCK ) ON t2.AccountNumber = t1.AccountNumber
                    JOIN dbo.Program AS t3 WITH ( NOLOCK ) ON t3.IdentityCode = @ProgramCode
                                                              AND t2.ProgramId = t3.Id
                    JOIN dbo.Product AS t4 WITH ( NOLOCK ) ON t4.Id = t2.ProductId
            WHERE   t4.ExternalId = @ProductExternalId
                                                          

    END
