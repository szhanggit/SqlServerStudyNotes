
CREATE PROCEDURE spGetCurrentDayMerchantReportDetailItems
    @ProgramCode VARCHAR(20) ,
    @MerchantCode VARCHAR(50) ,
    @ShopCode VARCHAR(50) ,
    @ProductExternalId VARCHAR(50)
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @TimeOffset VARCHAR(20) 
        DECLARE @CurrentLocalTime DATETIME
        DECLARE @TranLocalDate INT

        IF ( ISNULL(@ProgramCode, '') = '' )
            BEGIN
                SELECT  @ProgramCode = p.IdentityCode
                FROM    Merchant m
                        JOIN Program p ON m.ProgramId = p.Id
                WHERE   m.IdentityCode = @MerchantCode
            END
  
        SELECT  @TimeOffset = TimeOffset
        FROM    Program
        WHERE   IdentityCode = @ProgramCode

        IF ( LEFT(@TimeOffset, 1) = '-' )
            SET @CurrentLocalTime = GETUTCDATE() - SUBSTRING(@TimeOffset, 2,
                                                             LEN(@TimeOffset)
                                                             - 1)
        ELSE
            SET @CurrentLocalTime = GETUTCDATE() + @TimeOffset
        SET @TranLocalDate = CAST(CONVERT(VARCHAR(8), @CurrentLocalTime, 112) AS INT);

        WITH    Trans
                  AS ( SELECT   AccountNumber ,
                                TranType ,
                                TranAmount ,
                                TranLocalDateTime
                       FROM     dbo.[Transaction] WITH ( NOLOCK )
                       WHERE    ProgramCode = @ProgramCode
                                AND MerchantCode = @MerchantCode
                                AND ( ShopCode = @ShopCode
                                      OR ISNULL(@ShopCode, '') = ''
                                    )
                                AND TranLocalDate = @TranLocalDate
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

    END
