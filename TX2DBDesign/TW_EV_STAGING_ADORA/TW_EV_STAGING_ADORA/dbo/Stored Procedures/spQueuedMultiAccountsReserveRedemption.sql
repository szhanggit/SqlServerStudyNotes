
CREATE PROCEDURE [dbo].[spQueuedMultiAccountsReserveRedemption]
    @SessionId VARCHAR(50) ,
    @IsAccountHistory BIT ,
    @IsTranHistory BIT
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
            WITH    ReserveRedemption
                      AS ( SELECT   t1.* ,
                                    t3.TranCount
                           FROM     dbo.BUF_ReserveRedemption AS t1 WITH ( NOLOCK )
                                    LEFT JOIN dbo.BUF_ReserveRedemption AS t2
                                    WITH ( NOLOCK ) ON t1.SessionId = t2.SessionId
                                                       AND t1.AccountNumber = t2.AccountNumber
                                                       AND t1.BalanceAvailable < t2.BalanceAvailable
                                    JOIN ( SELECT   SessionId ,
                                                    AccountNumber ,
                                                    COUNT(*) AS TranCount
                                           FROM     dbo.BUF_ReserveRedemption
                                                    WITH ( NOLOCK )
                                           GROUP BY SessionId ,
                                                    AccountNumber
                                         ) AS t3 ON t3.SessionId = t1.SessionId
                                                    AND t3.AccountNumber = t1.AccountNumber
                           WHERE    t2.BalanceAvailable IS NULL
                         )
                UPDATE  t1
                SET     [BalanceAvailable] = t2.BalanceAvailable ,
                        [BalanceFrozen] = t2.BalanceFrozen ,
                        [Checksum] = t2.AccountCheckSum ,
                        [TranCount] = IIF(t2.CountDecrease = 1, t1.[TranCount]
                        - t2.TranCount, t1.[TranCount]) ,
                        [TranAmountAccumulated] = IIF(t2.AmountDecrease = 1, t1.[TranAmountAccumulated]
                        - ( t2.BalanceAvailable - t1.[BalanceAvailable] ), t1.[TranAmountAccumulated]) ,
                        [ModifyVersion] = t1.[ModifyVersion] + 1 ,
                        [Status] = t2.Status ,
                        [LastTranOn] = t2.LastTranOn
                FROM    [dbo].[Account] AS t1
                        JOIN ReserveRedemption AS t2 ON t1.AccountNumber = t2.AccountNumber
                                                        AND t1.ModifyVersion = t2.ModifyVersion
                                                        AND t1.ProgramId = t2.ProgramId
                WHERE   t2.SessionId = @SessionId

            SET @AccoutCount = @@ROWCOUNT         
	
            IF ( @IsAccountHistory = 1 )
                BEGIN
                    WITH    ReserveRedemption
                              AS ( SELECT   t1.* ,
                                            t3.TranCount
                                   FROM     dbo.BUF_ReserveRedemption AS t1
                                            WITH ( NOLOCK )
                                            LEFT JOIN dbo.BUF_ReserveRedemption
                                            AS t2 WITH ( NOLOCK ) ON t1.SessionId = t2.SessionId
                                                              AND t1.AccountNumber = t2.AccountNumber
                                                              AND t1.BalanceAvailable < t2.BalanceAvailable
                                            JOIN ( SELECT   SessionId ,
                                                            AccountNumber ,
                                                            COUNT(*) AS TranCount
                                                   FROM     dbo.BUF_ReserveRedemption
                                                            WITH ( NOLOCK )
                                                   GROUP BY SessionId ,
                                                            AccountNumber
                                                 ) AS t3 ON t3.SessionId = t1.SessionId
                                                            AND t3.AccountNumber = t1.AccountNumber
                                   WHERE    t2.BalanceAvailable IS NULL
                                 )
                        UPDATE  t1
                        SET     [BalanceAvailable] = t2.BalanceAvailable ,
                                [BalanceFrozen] = t2.BalanceFrozen ,
                                [Checksum] = t2.AccountCheckSum ,
                                [TranCount] = IIF(t2.CountDecrease = 1, t1.[TranCount]
                                - t2.TranCount, t1.[TranCount]) ,
                                [TranAmountAccumulated] = IIF(t2.AmountDecrease = 1, t1.[TranAmountAccumulated]
                                - ( t2.BalanceAvailable
                                    - t1.[BalanceAvailable] ), t1.[TranAmountAccumulated]) ,
                                [ModifyVersion] = t1.[ModifyVersion] + 1 ,
                                [Status] = t2.Status ,
                                [LastTranOn] = t2.LastTranOn
                        FROM    [dbo].[AccountHistory] AS t1
                                JOIN ReserveRedemption AS t2 ON t1.AccountNumber = t2.AccountNumber
                                                              AND t1.ModifyVersion = t2.ModifyVersion
                                                              AND t1.ProgramId = t2.ProgramId
                        WHERE   t2.SessionId = @SessionId

                    SET @AccoutCount = @AccoutCount + @@ROWCOUNT        

                    INSERT  INTO [dbo].[Account]
                            ( [AccountNumber] ,
                              [ProgramId] ,
                              [ProductId] ,
                              [ExternalOrderId] ,
                              [AccountNumberHashed] ,
                              [BalanceAvailable] ,
                              [BalanceFrozen] ,
                              [ValueType] ,
                              [TopupMode] ,
                              [Status] ,
                              [Checksum] ,
                              [TranCount] ,
                              [TranAmountAccumulated] ,
                              [AcceptanceLoopId] ,
                              [RestrictionId] ,
                              [ExpirationPolicyId] ,
                              [Password] ,
                              [ActiveFrom] ,
                              [ActiveTo] ,
                              [CreatedOn] ,
                              [LastTranOn] ,
                              [BlockedOn] ,
                              [ActivatedOn] ,
                              [ExpiredOn] ,
                              [ModifyVersion] ,
                              [AccountNumberLength] ,
                              [AccountGUID] ,
                              [IsNotifyClient] ,
                              [ClientNotificationProviderCode] ,
                              [ConsumeTime] ,
                              [ConsumeMerchantCode] ,
                              [ConsumeShopCode] ,
                              [ConsumeTerminalSSN] ,
                              [BalanceInitialized]
                            )
                            SELECT  t1.[AccountNumber] ,
                                    t1.[ProgramId] ,
                                    [ProductId] ,
                                    [ExternalOrderId] ,
                                    [AccountNumberHashed] ,
                                    t1.[BalanceAvailable] ,
                                    t1.[BalanceFrozen] ,
                                    [ValueType] ,
                                    [TopupMode] ,
                                    t1.[Status] ,
                                    [Checksum] ,
                                    [TranCount] ,
                                    [TranAmountAccumulated] ,
                                    [AcceptanceLoopId] ,
                                    [RestrictionId] ,
                                    [ExpirationPolicyId] ,
                                    [Password] ,
                                    [ActiveFrom] ,
                                    [ActiveTo] ,
                                    [CreatedOn] ,
                                    t1.[LastTranOn] ,
                                    [BlockedOn] ,
                                    [ActivatedOn] ,
                                    [ExpiredOn] ,
                                    t1.[ModifyVersion] ,
                                    [AccountNumberLength] ,
                                    [AccountGUID] ,
                                    [IsNotifyClient] ,
                                    [ClientNotificationProviderCode] ,
                                    [ConsumeTime] ,
                                    [ConsumeMerchantCode] ,
                                    [ConsumeShopCode] ,
                                    [ConsumeTerminalSSN] ,
                                    [BalanceInitialized]
                            FROM    [dbo].[AccountHistory] AS t1
                                    JOIN dbo.BUF_ReserveRedemption AS t2 ON t1.AccountNumber = t2.AccountNumber
                                                              AND t1.ProgramId = t2.ProgramId
                            WHERE   t2.SessionId = @SessionId
	
                    DELETE  t1
                    FROM    [dbo].[AccountHistory] AS t1
                            JOIN dbo.BUF_ReserveRedemption AS t2 ON t1.AccountNumber = t2.AccountNumber
                                                              AND t1.ProgramId = t2.ProgramId
                    WHERE   t2.SessionId = @SessionId
		
                END

            IF @AccoutCount = ( SELECT  COUNT(DISTINCT AccountNumber)
                                FROM    dbo.BUF_ReserveRedemption
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
                            JOIN dbo.BUF_ReserveRedemption AS t2 ON t1.[AccountNumber] = t2.AccountNumber
                                                              AND t1.[TranCode] = t2.TranCode
                    WHERE   t2.SessionId = @SessionId
		

                    UPDATE  t1
                    SET     [CheckSum] = t2.ReversedTranCheckSum ,
                            [RefundedAmount] = t2.RefundedAmount ,
                            [Status] = 2
                    FROM    [dbo].[Transaction] AS t1
                            JOIN dbo.BUF_ReserveRedemption AS t2 ON t1.[AccountNumber] = t2.AccountNumber
                                                              AND t1.TranCode = t2.ReversedTranCode
                    WHERE   t2.SessionId = @SessionId

                    IF ( @IsTranHistory = 1 )
                        BEGIN
                            UPDATE  t1
                            SET     [CheckSum] = t2.ReversedTranCheckSum ,
                                    [RefundedAmount] = t2.RefundedAmount ,
                                    [Status] = 2
                            FROM    [dbo].[TransactionHistory] AS t1
                                    JOIN dbo.BUF_ReserveRedemption AS t2 ON t1.[AccountNumber] = t2.AccountNumber
                                                              AND t1.TranCode = t2.ReversedTranCode
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
                        JOIN dbo.BUF_ReserveRedemption AS t2 ON t1.[AccountNumber] = t2.AccountNumber
                                                              AND t1.[TranCode] = t2.TranCode
                WHERE   t2.SessionId = @SessionId
            END

        DELETE  FROM dbo.BUF_PreAuthorization
        WHERE   SessionId = @SessionId

        SELECT  @ResponseCode;
    END

