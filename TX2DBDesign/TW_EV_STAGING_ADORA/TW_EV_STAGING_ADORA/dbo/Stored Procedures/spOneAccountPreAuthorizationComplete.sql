
CREATE PROCEDURE spOneAccountPreAuthorizationComplete
    @AccountNumber VARCHAR(50) ,
    @ProgramId INT,
    @BalanceAvailable INT,
    @BalanceFrozen INT,
    @AccountCheckSum VARCHAR(50),
    @ModifyVersion INT,
    @TransactionCheckSum VARCHAR(50),
    @SecurityKeyId INT,
    @TranLocalDateTime DATETIME,
    @TranLocalDate INT,
    @TranCode VARCHAR(50),
    @LastTranOn DATETIME,
    @Status INT,
    @TranCodeRef VARCHAR(50),
    @PreviousTransactionChecksum VARCHAR(50),
    @ConsumeTime DATETIME,
    @ConsumeMerchantCode VARCHAR(50),
    @ConsumeShopCode VARCHAR(50),
    @ConsumeTerminalSSN VARCHAR(50),
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
            SET     [BalanceAvailable] = @BalanceAvailable ,
                    [BalanceFrozen] = @BalanceFrozen ,
                    [Checksum] = @AccountCheckSum ,
                    [ModifyVersion] = t1.[ModifyVersion] + 1 ,
                    [LastTranOn] = @LastTranOn ,
                    [Status] = @Status ,
                    [TranCount] = t1.[TranCount] + 1 ,
                    [TranAmountAccumulated] = t1.[TranAmountAccumulated]
                    + t1.[BalanceAvailable] - @BalanceAvailable
                    + t1.[BalanceFrozen] - @BalanceFrozen ,
                    [ConsumeTime] = @ConsumeTime ,
                    [ConsumeMerchantCode] = @ConsumeMerchantCode ,
                    [ConsumeShopCode] = @ConsumeShopCode ,
                    [ConsumeTerminalSSN] = @ConsumeTerminalSSN
            FROM    [dbo].[Account] AS t1
            WHERE t1.[AccountNumber] = @AccountNumber AND t1.[ModifyVersion] = @ModifyVersion AND t1.[ProgramId] = @ProgramId

            SET @AccoutCount = @@ROWCOUNT
    
            IF ( @IsAccountHistory != 0 )
                BEGIN
                    UPDATE  t1
                    SET     [BalanceAvailable] = @BalanceAvailable ,
                            [BalanceFrozen] = @BalanceFrozen ,
                            [Checksum] = @AccountCheckSum ,
                            [ModifyVersion] = t1.[ModifyVersion] + 1 ,
                            [LastTranOn] = @LastTranOn ,
                            [Status] = @Status ,
                            [TranCount] = t1.[TranCount] + 1 ,
                            [TranAmountAccumulated] = t1.[TranAmountAccumulated]
                            + t1.[BalanceAvailable] - @BalanceAvailable ,
                            [ConsumeTime] = @ConsumeTime ,
                            [ConsumeMerchantCode] = @ConsumeMerchantCode ,
                            [ConsumeShopCode] = @ConsumeShopCode ,
                            [ConsumeTerminalSSN] = @ConsumeTerminalSSN
                    FROM    [dbo].[AccountHistory] AS t1
                    WHERE t1.[AccountNumber] = @AccountNumber AND t1.[ModifyVersion] = @ModifyVersion AND t1.[ProgramId] = @ProgramId

                    SET @AccoutCount = @AccoutCount + @@ROWCOUNT
  
                END

            IF @AccoutCount = 1
                BEGIN
                    UPDATE  t1
                    SET     [Status] = 4 ,
                            [CheckSum] = @PreviousTransactionChecksum
                    FROM    [dbo].[Transaction] AS t1
                    WHERE t1.AccountNumber = @AccountNumber AND t1.TranCode = @TranCodeRef

                    SET @TransCount = @@ROWCOUNT

                    IF @IsPreAuthorizedTransactionHistory > 0
                        BEGIN
                            UPDATE  t1
                            SET     [Status] = 4 ,
                                    [CheckSum] = @PreviousTransactionChecksum
                            FROM    [dbo].[TransactionHistory] AS t1
                            WHERE t1.AccountNumber = @AccountNumber AND t1.TranCode = @TranCodeRef

                            SET @TransCount = @TransCount + @@ROWCOUNT
                        END
                    

                    IF @TransCount = 1
                        BEGIN
                            SET @ResponseCode = '0000'

                            UPDATE  t1
                            SET     [TranLocalDate] = @TranLocalDate ,
                                    [TranLocalDateTime] = @TranLocalDateTime ,
                                    [ResponseCode] = @ResponseCode ,
                                    [ModifyVersion] = @ModifyVersion + 1 ,
                                    [BalanceAvailable] = @BalanceAvailable ,
                                    [BalanceFrozen] = @BalanceFrozen ,
                                    [CheckSum] = @TransactionCheckSum ,
                                    [SecurityKeyId] = @SecurityKeyId
                            FROM    [dbo].[Transaction] AS t1
                            WHERE t1.AccountNumber = @AccountNumber AND t1.TranCode = @TranCode
                     
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
                SET     [TranLocalDate] = @TranLocalDate ,
                        [TranLocalDateTime] = @TranLocalDateTime ,
                        [ResponseCode] = @ResponseCode ,
                        [ModifyVersion] = @ModifyVersion ,
                        [BalanceAvailable] = @BalanceAvailable ,
                        [BalanceFrozen] = @BalanceFrozen
                FROM    [dbo].[Transaction] AS t1
                WHERE t1.AccountNumber = @AccountNumber AND t1.TranCode = @TranCode
            END
        SELECT  @ResponseCode;
    END
