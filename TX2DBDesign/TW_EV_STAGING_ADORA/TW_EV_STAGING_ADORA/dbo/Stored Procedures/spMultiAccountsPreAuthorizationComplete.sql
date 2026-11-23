
CREATE PROCEDURE spMultiAccountsPreAuthorizationComplete
    @SessionId VARCHAR(50) ,
    @IsAccountHistory BIT ,
    @IsPreAuthorizedTransactionHistory BIT
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

            UPDATE  t1
            SET     [BalanceAvailable] = t2.BalanceAvailable ,
                    [BalanceFrozen] = t2.BalanceFrozen ,
                    [Checksum] = t2.AccountCheckSum ,
                    [ModifyVersion] = t1.[ModifyVersion] + 1 ,
                    [LastTranOn] = t2.LastTranOn ,
                    [Status] = t2.Status ,
                    [TranCount] = t1.[TranCount] + t2.TranCount ,
                    [TranAmountAccumulated] = t1.[TranAmountAccumulated]
                    + t1.[BalanceAvailable] - t2.BalanceAvailable
                    + t1.[BalanceFrozen] - t2.BalanceFrozen ,
                    [ConsumeTime] = t2.ConsumeTime ,
                    [ConsumeMerchantCode] = t2.ConsumeMerchantCode ,
                    [ConsumeShopCode] = t2.ConsumeShopCode ,
                    [ConsumeTerminalSSN] = t2.ConsumeTerminalSSN
            FROM    [dbo].[Account] AS t1
                    JOIN
					(
                        --find min balance item, means it do last
                        SELECT * FROM 
                            (SELECT *, ROW_NUMBER() OVER(PARTITION BY AccountNumber ORDER BY BalanceFrozen) rowNumber, COUNT(1) OVER(PARTITION BY AccountNumber) TranCount
                                FROM dbo.BUF_PreAuthorizationComplete WITH(NOLOCK) WHERE SessionId = @SessionId
                            ) t 
                        WHERE t.rowNumber = 1
                    ) AS t2 ON t1.AccountNumber = t2.AccountNumber AND t1.ProgramId = t2.ProgramId AND t1.ModifyVersion = t2.ModifyVersion
            WHERE   t2.SessionId = @SessionId

            SET @AccoutCount = @@ROWCOUNT
    
            IF ( @IsAccountHistory != 0 )
                BEGIN
                    UPDATE  t1
                    SET     [BalanceAvailable] = t2.BalanceAvailable ,
                            [BalanceFrozen] = t2.BalanceFrozen ,
                            [Checksum] = t2.AccountCheckSum ,
                            [ModifyVersion] = t1.[ModifyVersion] + 1 ,
                            [LastTranOn] = t2.LastTranOn ,
                            [Status] = t2.[Status] ,
                            [TranCount] = t1.[TranCount] + t2.TranCount ,
                            [TranAmountAccumulated] = t1.[TranAmountAccumulated]
                            + t1.[BalanceAvailable] - t2.BalanceAvailable ,
                            [ConsumeTime] = t2.ConsumeTime ,
                            [ConsumeMerchantCode] = t2.ConsumeMerchantCode ,
                            [ConsumeShopCode] = t2.ConsumeShopCode ,
                            [ConsumeTerminalSSN] = t2.ConsumeTerminalSSN
                    FROM    [dbo].[AccountHistory] AS t1
                            JOIN
							(
								--find min balance item, means it do last
								SELECT * FROM 
									(SELECT *, ROW_NUMBER() OVER(PARTITION BY AccountNumber ORDER BY BalanceFrozen) rowNumber, COUNT(1) OVER(PARTITION BY AccountNumber) TranCount
										FROM dbo.BUF_PreAuthorizationComplete WITH(NOLOCK) WHERE SessionId = @SessionId
									) t 
								WHERE t.rowNumber = 1
							) AS t2 ON t1.AccountNumber = t2.AccountNumber AND t1.ProgramId = t2.ProgramId AND t1.ModifyVersion = t2.ModifyVersion
                    WHERE   t2.SessionId = @SessionId

                    SET @AccoutCount = @AccoutCount + @@ROWCOUNT
  
                END

            IF @AccoutCount = ( SELECT  COUNT(DISTINCT AccountNumber)
                                FROM    dbo.BUF_PreAuthorizationComplete WITH ( NOLOCK )
                                WHERE   SessionId = @SessionId
                              )
                BEGIN
                    UPDATE  t1
                    SET     [Status] = 4 ,
                            [CheckSum] = t2.PreviousTransactionChecksum
                    FROM    [dbo].[Transaction] AS t1
                            JOIN dbo.BUF_PreAuthorizationComplete AS t2 ON t1.AccountNumber = t2.AccountNumber
                                                              AND t1.TranCode = t2.TranCodeRef
                    WHERE   t2.SessionId = @SessionId

                    SET @TransCount = @@ROWCOUNT

                    IF @IsPreAuthorizedTransactionHistory > 0
                        BEGIN
                            UPDATE  t1
                            SET     [Status] = 4 ,
                                    [CheckSum] = t2.PreviousTransactionChecksum
                            FROM    [dbo].[TransactionHistory] AS t1
                                    JOIN dbo.BUF_PreAuthorizationComplete AS t2 ON t1.AccountNumber = t2.AccountNumber
                                                              AND t1.TranCode = t2.TranCodeRef
                            WHERE   t2.SessionId = @SessionId

                            SET @TransCount = @TransCount + @@ROWCOUNT
                        END
                    

                    IF @TransCount = ( SELECT   COUNT(*)
                                       FROM     dbo.BUF_PreAuthorizationComplete
                                       WHERE    SessionId = @SessionId
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
                                    JOIN dbo.BUF_PreAuthorizationComplete AS t2 ON t1.AccountNumber = t2.AccountNumber
                                                              AND t1.TranCode = t2.TranCode
                            WHERE   t2.SessionId = @SessionId
                     
                        END
                    ELSE
                        BEGIN
                            SET @ResponseCode = '0018'
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
                UPDATE  t1
                SET     [TranLocalDate] = t2.TranLocalDate ,
                        [TranLocalDateTime] = t2.TranLocalDateTime ,
                        [ResponseCode] = @ResponseCode ,
                        [ModifyVersion] = t2.ModifyVersion ,
                        [BalanceAvailable] = t2.BalanceAvailable ,
                        [BalanceFrozen] = t2.BalanceFrozen
                FROM    [dbo].[Transaction] AS t1
                        JOIN dbo.BUF_PreAuthorizationComplete AS t2 ON t1.AccountNumber = t2.AccountNumber
                                                              AND t1.TranCode = t2.TranCode
                WHERE   t2.SessionId = @SessionId
            END

        DELETE  FROM dbo.BUF_PreAuthorizationComplete
        WHERE   SessionId = @SessionId

        SELECT  @ResponseCode;

    END
