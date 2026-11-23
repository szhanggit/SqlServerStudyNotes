
CREATE PROCEDURE spClearingStatisticInfo @ClearingId BIGINT
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @ChangeInvoicePrepaidAmount INT
        DECLARE @ChangeInvoicePostpaidAmount INT
        DECLARE @ChangeInvoiceCount INT

        SELECT  @ChangeInvoicePrepaidAmount = SUM(IIF(t6.IsPrepaid = 1, ISNULL(t6.FaceValue,
                                                              0), 0)) ,
                @ChangeInvoicePostpaidAmount = SUM(IIF(t6.IsPrepaid = 0, ISNULL(t6.FaceValue,
                                                              0), 0)) ,
                @ChangeInvoiceCount = COUNT(*)
        FROM    dbo.MultiAccountsTransaction AS t1 WITH ( NOLOCK )
                JOIN dbo.MultiAccountsTransactionDetail AS t2 WITH ( NOLOCK ) ON t2.MultiAccountsTransactionId = t1.Id
                                                              AND t1.TranType = 902
                JOIN dbo.Program AS t3 WITH ( NOLOCK ) ON t1.ProgramCode = t3.IdentityCode
                INNER JOIN dbo.Account AS t4 WITH ( NOLOCK ) ON t4.AccountNumber = t2.AccountNumber
                                                              AND t4.ProgramId = t3.Id
                                                              AND t4.ConsumeShopCode = t1.ShopCode
                                                              AND t4.Status = 32
                JOIN dbo.Clearing AS t5 WITH ( NOLOCK ) ON t1.MerchantCode = t5.MerchantCode
                                                           AND t1.ShopCode = t5.ShopCode
                                                           AND t1.TerminalCode = t5.TerminalCode
                                                           AND t1.ProgramCode = t5.ProgramCode
                                                           AND t1.BusinessDay = t5.BusinessDay
                                                           AND ( t1.ShiftCode = t5.ShiftCode
                                                              OR t5.ClearingType = 2
                                                              )
                                                           AND t5.Id = @ClearingId
                JOIN dbo.Product AS t6 WITH ( NOLOCK ) ON t6.Id = t4.ProductId
        IF @ChangeInvoiceCount < ( SELECT   COUNT(*)
                                   FROM     dbo.MultiAccountsTransaction AS t1
                                            WITH ( NOLOCK )
                                            JOIN dbo.MultiAccountsTransactionDetail
                                            AS t2 WITH ( NOLOCK ) ON t2.MultiAccountsTransactionId = t1.Id
                                                              AND t1.TranType = 902
                                            JOIN dbo.Clearing AS t5 WITH ( NOLOCK ) ON t1.MerchantCode = t5.MerchantCode
                                                              AND t1.ShopCode = t5.ShopCode
                                                              AND t1.ProgramCode = t5.ProgramCode
                                                              AND t1.TerminalCode = t5.TerminalCode
                                                              AND t1.BusinessDay = t5.BusinessDay
                                                              AND ( t1.ShiftCode = t5.ShiftCode
                                                              OR t5.ClearingType = 2
                                                              )
                                                              AND t5.Id = @ClearingId
                                 )
            BEGIN 
                SELECT  @ChangeInvoicePrepaidAmount = SUM(IIF(t6.IsPrepaid = 1, ISNULL(t6.FaceValue,
                                                              0), 0)) ,
                        @ChangeInvoicePostpaidAmount = SUM(IIF(t6.IsPrepaid = 0, ISNULL(t6.FaceValue,
                                                              0), 0))
                FROM    dbo.MultiAccountsTransaction AS t1 WITH ( NOLOCK )
                        JOIN dbo.MultiAccountsTransactionDetail AS t2 WITH ( NOLOCK ) ON t2.MultiAccountsTransactionId = t1.Id
                                                              AND t1.TranType = 902
                        JOIN dbo.Program AS t3 WITH ( NOLOCK ) ON t1.ProgramCode = t3.IdentityCode
                        INNER JOIN dbo.AccountHistory AS t4 WITH ( NOLOCK ) ON t4.AccountNumber = t2.AccountNumber
                                                              AND t4.ProgramId = t3.Id
                                                              AND t4.ConsumeShopCode = t1.ShopCode
                                                              AND t4.Status = 32
                        JOIN dbo.Clearing AS t5 WITH ( NOLOCK ) ON t1.MerchantCode = t5.MerchantCode
                                                              AND t1.ShopCode = t5.ShopCode
                                                              AND t1.ProgramCode = t5.ProgramCode
                                                              AND t1.TerminalCode = t5.TerminalCode
                                                              AND t1.BusinessDay = t5.BusinessDay
                                                              AND ( t1.ShiftCode = t5.ShiftCode
                                                              OR t5.ClearingType = 2
                                                              )
                                                              AND t5.Id = @ClearingId
                        JOIN dbo.Product AS t6 WITH ( NOLOCK ) ON t6.Id = t4.ProductId

            END



        SELECT  ( SUM(IIF(t6.TranType = 103, ISNULL(t4.FaceValue, 0), 0))
                  + ISNULL(@ChangeInvoicePrepaidAmount, 0) ) / 100 AS PrepaidSalesAmount ,
                ( SUM(IIF(t6.TranType = 203, ISNULL(t4.FaceValue, 0), 0))
                  + ISNULL(@ChangeInvoicePrepaidAmount, 0) ) / 100 AS PrepaidRefundedAmount ,
                SUM(IIF(t6.TranType = 103, ISNULL(t4.FaceValue, 0), ISNULL(t4.FaceValue,
                                                              0) * ( -1 )))
                / 100 AS PrepaidTotalAmount ,
                ( SUM(IIF(t6.TranType = 103, ISNULL(t7.FaceValue, 0), 0))
                  + ISNULL(@ChangeInvoicePostpaidAmount, 0) ) / 100 AS PostpaidSalesAmount ,
                ( SUM(IIF(t6.TranType = 203, ISNULL(t7.FaceValue, 0), 0))
                  + ISNULL(@ChangeInvoicePostpaidAmount, 0) ) / 100 AS PostpaidRefundedAmount ,
                SUM(IIF(t6.TranType = 103, ISNULL(t7.FaceValue, 0), ISNULL(t7.FaceValue,
                                                              0) * ( -1 )))
                / 100 AS PostpaidTotalAmount
        FROM    dbo.Clearing AS t1 WITH ( NOLOCK )
                LEFT JOIN dbo.ClearingDetail AS t2 WITH ( NOLOCK ) ON t2.ClearingId = t1.Id
                                                              AND t1.Id = @ClearingId
                LEFT JOIN dbo.Account AS t3 WITH ( NOLOCK ) ON t3.AccountNumber = t2.AccountNumber
                LEFT   JOIN ( SELECT    *
                              FROM      dbo.Product WITH ( NOLOCK )
                              WHERE     IsPrepaid = 1
                            ) AS t4 ON t4.Id = t3.ProductId
                LEFT  JOIN dbo.MultiAccountsTransaction AS t6 WITH ( NOLOCK ) ON t6.ProgramCode = t1.ProgramCode
                                                              AND t1.MerchantCode = t6.MerchantCode
                                                              AND t1.ShopCode = t6.ShopCode
                                                              AND t1.TerminalCode = t6.TerminalCode
                                                              AND t2.TerminalSSN = t6.TerminalSSN
                LEFT   JOIN ( SELECT    *
                              FROM      dbo.Product WITH ( NOLOCK )
                              WHERE     IsPrepaid = 0
                            ) AS t7 ON t7.Id = t3.ProductId




        
    END
