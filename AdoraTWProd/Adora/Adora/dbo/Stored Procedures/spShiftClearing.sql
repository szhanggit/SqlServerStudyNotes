
CREATE PROCEDURE spShiftClearing @ClearingId BIGINT
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @ResponseCode VARCHAR(5)

        BEGIN TRAN
        BEGIN TRY

            WITH    NoClearing
                      AS ( SELECT DISTINCT
                                    t1.* ,
                                    t2.AccountNumber ,
                                    t2.TranCode
                           FROM     dbo.MultiAccountsTransaction t1 WITH ( NOLOCK )
                                    JOIN dbo.MultiAccountsTransactionDetail AS t2
                                    WITH ( NOLOCK ) ON t2.MultiAccountsTransactionId = t1.Id
                                    JOIN dbo.Clearing AS t4 WITH ( NOLOCK ) ON t1.ProgramCode = t4.ProgramCode
                                                              AND t1.MerchantCode = t4.MerchantCode
                                                              AND t1.ShopCode = t4.ShopCode
                                                              AND t1.TerminalCode = t4.TerminalCode
                                                              AND t1.BusinessDay = t4.BusinessDay
                                                              AND t1.ShiftCode = t4.ShiftCode
                           WHERE    ( t1.TranType = 103
                                      OR t1.TranType = 203
                                    )
                                    AND t1.ShiftClearingId IS NULL
                                    AND t2.TranCode IS NOT NULL
                                    AND t4.Id = @ClearingId
                                    AND t1.ResponseCode = '0000'
                         )
                INSERT  INTO dbo.ClearingDiff
                        ( ClearingId ,
                          TerminalSSN ,
                          AccountNumber ,
                          TranCode ,
                          ResponseCode
                        )
                        SELECT  @ClearingId ,
                                ISNULL(t2.TerminalSSN, t3.TerminalSSN) ,
                                ISNULL(t2.AccountNumber, t3.AccountNumber) ,
                                ISNULL(t2.TranCode, t3.TranCode) ,
                                IIF(t2.Id IS NULL, '0109', '0108')
                        FROM    dbo.Clearing AS t1 WITH ( NOLOCK )
                                JOIN dbo.ClearingDetail AS t2 WITH ( NOLOCK ) ON t2.ClearingId = t1.Id
                                                              AND t1.Id = @ClearingId
                                FULL OUTER  JOIN NoClearing AS t3 ON t3.TerminalSSN = t2.TerminalSSN
                                                              AND t3.AccountNumber = t2.AccountNumber
                                                              AND t3.TranCode = t2.TranCode
                        WHERE   t2.Id IS NULL
                                OR t3.Id IS NULL
                                    


            IF EXISTS ( SELECT  *
                        FROM    dbo.ClearingDiff
                        WHERE   ClearingId = @ClearingId )
                BEGIN
                    SET @ResponseCode = '0079'
                    UPDATE  dbo.Clearing
                    SET     ResponseCode = @ResponseCode
                    WHERE   Id = @ClearingId
                END
            ELSE
                BEGIN
                    SET @ResponseCode = '0000'
                    UPDATE  t1
                    SET     ShiftClearingId = @ClearingId
                    FROM    dbo.MultiAccountsTransaction t1
                            JOIN dbo.MultiAccountsTransactionDetail AS t2 WITH ( NOLOCK ) ON t2.MultiAccountsTransactionId = t1.Id
                            JOIN dbo.ClearingDetail AS t3 WITH ( NOLOCK ) ON t3.TerminalSSN = t1.TerminalSSN
                            JOIN dbo.Clearing AS t4 WITH ( NOLOCK ) ON t4.Id = t3.ClearingId
                                                              AND t1.ProgramCode = t4.ProgramCode
                                                              AND t1.MerchantCode = t4.MerchantCode
                                                              AND t1.ShopCode = t4.ShopCode
                                                              AND t1.TerminalCode = t4.TerminalCode
                                                              AND t1.BusinessDay = t4.BusinessDay
                                                              AND t1.ShiftCode = t4.ShiftCode
                    WHERE   ( t1.TranType = 103
                              OR t1.TranType = 203
                            )
                            AND t1.ShiftClearingId IS NULL
                            AND t2.TranCode IS NOT NULL
                            AND t4.Id = @ClearingId
                            AND t1.ResponseCode = '0000'
                    

                    UPDATE  dbo.Clearing
                    SET     ResponseCode = @ResponseCode
                    WHERE   Id = @ClearingId



                END

        END TRY
        BEGIN CATCH

            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;

        SELECT  @ResponseCode

    END
