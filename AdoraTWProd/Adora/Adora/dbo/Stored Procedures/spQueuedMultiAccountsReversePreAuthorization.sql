
CREATE PROCEDURE spQueuedMultiAccountsReversePreAuthorization
    @SessionId VARCHAR(50) ,
    @IsAccountHistory BIT ,
    @IsReversedTransactionHistory BIT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @ResponseCode VARCHAR(5)
        DECLARE @AccoutCount INT
        DECLARE @TransCount INT

        BEGIN TRAN

        BEGIN TRY
            WITH    ReversePreAuthorization
                      AS ( SELECT   t1.*
                           FROM     dbo.BUF_ReversePreAuthorization AS t1 WITH ( NOLOCK )
                                    LEFT JOIN dbo.BUF_ReversePreAuthorization
                                    AS t2 WITH ( NOLOCK ) ON t1.SessionId = t2.SessionId
                                                             AND t1.AccountNumber = t2.AccountNumber
                                                             AND t1.BalanceAvailable < t2.BalanceAvailable
                           WHERE    t2.BalanceAvailable IS NULL
                         )
                UPDATE  t1
                SET     [BalanceAvailable] = t2.BalanceAvailable ,
                        [BalanceFrozen] = t2.BalanceFrozen ,
                        [Checksum] = t2.AccountCheckSum ,
                        [ModifyVersion] = t1.[ModifyVersion] + 1 ,
                        [LastTranOn] = t2.LastTranOn
                FROM    [dbo].[Account] AS t1
                        JOIN ReversePreAuthorization AS t2 ON t1.[AccountNumber] = t2.AccountNumber
                                                              AND t1.[ModifyVersion] = t2.ModifyVersion
                                                              AND t1.[ProgramId] = t2.ProgramId
                WHERE   t2.SessionId = @SessionId
		
            SET @AccoutCount = @@ROWCOUNT

            IF @IsAccountHistory = 1
                BEGIN
                    WITH    ReversePreAuthorization
                              AS ( SELECT   t1.*
                                   FROM     dbo.BUF_ReversePreAuthorization AS t1
                                            WITH ( NOLOCK )
                                            LEFT JOIN dbo.BUF_ReversePreAuthorization
                                            AS t2 WITH ( NOLOCK ) ON t1.SessionId = t2.SessionId
                                                              AND t1.AccountNumber = t2.AccountNumber
                                                              AND t1.BalanceAvailable < t2.BalanceAvailable
                                   WHERE    t2.BalanceAvailable IS NULL
                                 )
                        UPDATE  t1
                        SET     [BalanceAvailable] = t2.BalanceAvailable ,
                                [BalanceFrozen] = t2.BalanceFrozen ,
                                [Checksum] = t2.AccountCheckSum ,
                                [ModifyVersion] = t1.[ModifyVersion] + 1 ,
                                [LastTranOn] = t2.LastTranOn
                        FROM    [dbo].[AccountHistory] AS t1
                                JOIN ReversePreAuthorization AS t2 ON t1.[AccountNumber] = t2.AccountNumber
                                                              AND t1.[ModifyVersion] = t2.ModifyVersion
                                                              AND t1.[ProgramId] = t2.ProgramId
                        WHERE   t2.SessionId = @SessionId

                    SET @AccoutCount = @AccoutCount + @@ROWCOUNT
                END

            IF @AccoutCount = ( SELECT  COUNT(DISTINCT AccountNumber)
                                FROM    dbo.BUF_ReversePreAuthorization WITH ( NOLOCK )
                                WHERE   SessionId = @SessionId
                              )
                BEGIN
                    SET @ResponseCode = '0000'

                    UPDATE  t1
                    SET     [TranLocalDate] = t2.TranLocalDate ,
                            [TranLocalDateTime] = t2.TranLocalDateTime ,
                            [ResponseCode] = @ResponseCode ,
                            [ModifyVersion] = t2.ModifyVersion + 1 ,
                            [BalanceAvailable] = t2.BalanceAvailable ,
                            [BalanceFrozen] = t2.BalanceFrozen ,
                            [CheckSum] = t2.TransactionCheckSum ,
                            [SecurityKeyId] = t2.SecurityKeyId
                    FROM    [dbo].[Transaction] AS t1
                            JOIN dbo.BUF_ReversePreAuthorization AS t2 ON t1.AccountNumber = t2.AccountNumber
                                                              AND t1.TranCode = t2.TranCode
                    WHERE   t2.SessionId = @SessionId

                    UPDATE  t1
                    SET     [Status] = 2 ,
                            [CheckSum] = t2.ReversedTranCheckSum
                    FROM    [dbo].[Transaction] AS t1
                            JOIN dbo.BUF_ReversePreAuthorization AS t2 ON t1.AccountNumber = t2.AccountNumber
                                                              AND t1.TranCode = t2.TranCodeRef
                    WHERE   t2.SessionId = @SessionId


                    IF @IsReversedTransactionHistory > 0
                        BEGIN
                            UPDATE  t1
                            SET     [Status] = 2 ,
                                    [CheckSum] = t2.ReversedTranCheckSum
                            FROM    [dbo].[TransactionHistory] AS t1
                                    JOIN dbo.BUF_ReversePreAuthorization AS t2 ON t1.AccountNumber = t2.AccountNumber
                                                              AND t1.TranCode = t2.TranCodeRef
                            WHERE   t2.SessionId = @SessionId
                        END
                    
                END
            ELSE
                BEGIN
                    SET @ResponseCode = '0018'

                  
                END
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
        END CATCH;

        IF @@TRANCOUNT > 0
            AND @ResponseCode = '0000'
            BEGIN
                COMMIT TRANSACTION;
            END
        ELSE
            IF @@TRANCOUNT > 0
                AND @ResponseCode != '0000'
                BEGIN
                    ROLLBACK TRANSACTION;
                END

        IF @ResponseCode = '0018'
            BEGIN
                UPDATE  [dbo].[Transaction]
                SET     [TranLocalDate] = t2.TranLocalDate ,
                        [TranLocalDateTime] = t2.TranLocalDateTime ,
                        [ResponseCode] = @ResponseCode ,
                        [ModifyVersion] = t2.ModifyVersion ,
                        [BalanceAvailable] = t2.BalanceAvailable ,
                        [BalanceFrozen] = t2.BalanceFrozen
                FROM    [dbo].[Transaction] AS t1
                        JOIN dbo.BUF_ReversePreAuthorization AS t2 ON t1.AccountNumber = t2.AccountNumber
                                                              AND t1.TranCode = t2.TranCode
                WHERE   t2.SessionId = @SessionId
            END
                                                           
        DELETE  FROM dbo.BUF_PreAuthorization
        WHERE   SessionId = @SessionId

        SELECT  @ResponseCode;
    END
