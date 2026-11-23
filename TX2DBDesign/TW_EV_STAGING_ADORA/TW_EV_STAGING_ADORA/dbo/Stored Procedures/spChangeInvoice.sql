
CREATE PROCEDURE spChangeInvoice
    @MultiAccountsTransactionId BIGINT
AS
    BEGIN
        SET NOCOUNT ON;

        IF NOT EXISTS ( SELECT  *
                        FROM    dbo.MultiAccountsTransactionDetail AS t1 WITH ( NOLOCK )
                                LEFT JOIN dbo.Account AS t2 WITH ( NOLOCK ) ON t2.AccountNumber = t1.AccountNumber
                        WHERE   t2.AccountNumber IS NULL
                                AND t1.MultiAccountsTransactionId = @MultiAccountsTransactionId )
            BEGIN
                SELECT  t2.AccountNumber ,
                        ISNULL(t4.Status, -1) AS [Status],
						t2.Id DetailId
                FROM    dbo.MultiAccountsTransaction AS t1 WITH ( NOLOCK )
                        JOIN dbo.MultiAccountsTransactionDetail AS t2 WITH ( NOLOCK ) ON t2.MultiAccountsTransactionId = t1.Id
                        JOIN dbo.Program AS t3 WITH ( NOLOCK ) ON t1.ProgramCode = t3.IdentityCode
                        INNER JOIN dbo.Account AS t4 WITH ( NOLOCK ) ON t4.AccountNumber = t2.AccountNumber
                                                              AND t4.ProgramId = t3.Id
                                                              AND t4.ConsumeShopCode = t1.ShopCode
                WHERE   t1.Id = @MultiAccountsTransactionId
            END

        ELSE
            BEGIN
                SELECT  t2.AccountNumber ,
                        ISNULL(t4.Status, -1) AS [Status],
						t2.Id DetailId
                FROM    dbo.MultiAccountsTransaction AS t1 WITH ( NOLOCK )
                        JOIN dbo.MultiAccountsTransactionDetail AS t2 WITH ( NOLOCK ) ON t2.MultiAccountsTransactionId = t1.Id
                        JOIN dbo.Program AS t3 WITH ( NOLOCK ) ON t1.ProgramCode = t3.IdentityCode
                        INNER JOIN dbo.Account AS t4 WITH ( NOLOCK ) ON t4.AccountNumber = t2.AccountNumber
                                                              AND t4.ProgramId = t3.Id
                                                              AND t4.ConsumeShopCode = t1.ShopCode
                WHERE   t1.Id = @MultiAccountsTransactionId
                UNION
                SELECT  t2.AccountNumber ,
						ISNULL(t4.Status, -1) AS [Status],
						t2.Id DetailId
                FROM    dbo.MultiAccountsTransaction AS t1 WITH ( NOLOCK )
                        JOIN dbo.MultiAccountsTransactionDetail AS t2 WITH ( NOLOCK ) ON t2.MultiAccountsTransactionId = t1.Id
                        JOIN dbo.Program AS t3 WITH ( NOLOCK ) ON t1.ProgramCode = t3.IdentityCode
                        INNER JOIN dbo.AccountHistory AS t4 WITH ( NOLOCK ) ON t4.AccountNumber = t2.AccountNumber
                                                              AND t4.ProgramId = t3.Id
                                                              AND t4.ConsumeShopCode = t1.ShopCode
                WHERE   t1.Id = @MultiAccountsTransactionId

            END

    END
