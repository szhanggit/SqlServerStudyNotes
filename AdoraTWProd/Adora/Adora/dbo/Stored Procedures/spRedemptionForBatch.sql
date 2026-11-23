
CREATE PROCEDURE spRedemptionForBatch
    @AccountNumber VARCHAR(50) ,
    @ProgramId INT ,
    @BalanceAvailable INT ,
    @BalanceFrozen INT ,
    @AccountCheckSum VARCHAR(50) ,
    @ModifyVersion INT ,
    @TransactionCheckSum VARCHAR(50) ,
    @SecurityKeyId INT ,
    @TranLocalDateTime DATETIME ,
    @TranLocalDate INT ,
    @TranCode VARCHAR(50) ,
    @Status INT ,
    @LastTranOn DATETIME ,
    @ResponseCode VARCHAR(5) OUTPUT ,
    @ConsumeTime DATETIME = NULL ,
    @ConsumeMerchantCode VARCHAR(50) = NULL ,
    @ConsumeShopCode VARCHAR(50) = NULL ,
    @ConsumeTerminalSSN VARCHAR(50) = NULL
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        BEGIN TRAN

        BEGIN TRY
            UPDATE  [dbo].[Account]
            SET     [BalanceAvailable] = @BalanceAvailable ,
                    [BalanceFrozen] = @BalanceFrozen ,
                    [Checksum] = @AccountCheckSum ,
                    [TranCount] = [TranCount] + 1 ,
                    [TranAmountAccumulated] = [TranAmountAccumulated]
                    + [BalanceAvailable] - @BalanceAvailable ,
                    [ModifyVersion] = [ModifyVersion] + 1 ,
                    [Status] = @Status ,
                    [LastTranOn] = @LastTranOn ,
                    [ConsumeTime] = @ConsumeTime ,
                    [ConsumeMerchantCode] = @ConsumeMerchantCode ,
                    [ConsumeShopCode] = @ConsumeShopCode ,
                    [ConsumeTerminalSSN] = @ConsumeTerminalSSN
            WHERE   [AccountNumber] = @AccountNumber
                    AND [ModifyVersion] = @ModifyVersion
                    AND [ProgramId] = @ProgramId

            IF @@ROWCOUNT <> 0
                BEGIN
                    SET @ResponseCode = '0000'

                    UPDATE  [dbo].[TransactionBufferForBatch]
                    SET     [TranLocalDate] = @TranLocalDate ,
                            [TranLocalDateTime] = @TranLocalDateTime ,
                            [ResponseCode] = @ResponseCode ,
                            [ModifyVersion] = @ModifyVersion + 1 ,
                            [BalanceAvailable] = @BalanceAvailable ,
                            [BalanceFrozen] = @BalanceFrozen ,
                            [CheckSum] = @TransactionCheckSum ,
                            [SecurityKeyId] = @SecurityKeyId
                    WHERE   [AccountNumber] = @AccountNumber
                            AND [TranCode] = @TranCode
                END
            ELSE
                BEGIN
                    SET @ResponseCode = '0018'

                    UPDATE  [dbo].[TransactionBufferForBatch]
                    SET     [TranLocalDate] = @TranLocalDate ,
                            [TranLocalDateTime] = @TranLocalDateTime ,
                            [ResponseCode] = @ResponseCode ,
                            [ModifyVersion] = @ModifyVersion ,
                            [BalanceAvailable] = @BalanceAvailable ,
                            [BalanceFrozen] = @BalanceFrozen
                    WHERE   [AccountNumber] = @AccountNumber
                            AND [TranCode] = @TranCode
                END
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
    END
