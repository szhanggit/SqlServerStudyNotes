CREATE PROCEDURE dbo.spDoTranForBatch
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
    SET NOCOUNT ON;

    BEGIN TRAN
    BEGIN TRY
        UPDATE  [dbo].[Account]
        SET     [BalanceAvailable] = @BalanceAvailable ,
                [BalanceFrozen] = @BalanceFrozen ,
				[Status] = @Status ,
                [Checksum] = @AccountCheckSum ,
                [TranCount] = [TranCount] + 1 ,
                [TranAmountAccumulated] = [TranAmountAccumulated] + [BalanceAvailable] - @BalanceAvailable ,
                [LastTranOn] = @LastTranOn ,
				[ModifyVersion] = [ModifyVersion] + 1 ,
                [ConsumeTime] = @ConsumeTime ,
                [ConsumeMerchantCode] = @ConsumeMerchantCode ,
                [ConsumeShopCode] = @ConsumeShopCode ,
                [ConsumeTerminalSSN] = @ConsumeTerminalSSN
        WHERE   [AccountNumber] = @AccountNumber
                AND [ProgramId] = @ProgramId
				AND [ModifyVersion] = @ModifyVersion

		IF @@ROWCOUNT <> 0
			DECLARE @tranCodeRef VARCHAR(50) = NULL
			SELECT @tranCodeRef = TranCodeRef FROM dbo.TransactionBufferForBatch WITH(NOLOCK) WHERE AccountNumber = @AccountNumber AND TranCode = @TranCode
			IF @tranCodeRef IS NOT NULL AND @tranCodeRef <> ''
			BEGIN
				UPDATE dbo.[Transaction] SET Status = 2 WHERE AccountNumber = @AccountNumber AND TranCode = @tranCodeRef

				IF @@ROWCOUNT <> 0
					SET @ResponseCode = '0000'
				ELSE
				BEGIN
					UPDATE dbo.[TransactionHistory] SET Status = 2 WHERE AccountNumber = @AccountNumber AND TranCode = @tranCodeRef

					IF @@ROWCOUNT <> 0
						SET @ResponseCode = '0000'
					ELSE
						SET @ResponseCode = '0029'
				END
			END
		ELSE
			SET @ResponseCode = '0018'

        IF @ResponseCode = '0000' 
            BEGIN
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
