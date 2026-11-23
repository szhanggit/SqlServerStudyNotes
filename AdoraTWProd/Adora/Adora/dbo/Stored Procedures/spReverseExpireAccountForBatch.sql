
CREATE PROCEDURE spReverseExpireAccountForBatch
    @AccountNumber VARCHAR(50) ,
    @ProgramId INT ,
    @AccountCheckSum VARCHAR(50) ,
    @ModifyVersion INT ,
    @Status INT ,
    @ActiveTo DATETIME ,
    @LastTranOn DATETIME ,
    @MerchantCode VARCHAR(50) ,
    @TerminalSSN VARCHAR(50) ,
    @TranUtcDateTimeL BIGINT ,
    @TranType SMALLINT ,
    @TranAmount INT ,
    @SecurityKeyId INT ,
    @Checksum VARCHAR(50) ,
    @TranLocalDateTime DATETIME ,
    @TranLocalDate INT ,
    @IsHistory BIT ,
    @IsSuccess BIT OUTPUT ,
    @BatchTransactionDetailId BIGINT ,
    @TranCode VARCHAR(50) OUTPUT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        BEGIN TRAN

        BEGIN TRY
            IF ( @IsHistory = 0 )
                BEGIN
                    UPDATE  [dbo].[Account]
                    SET     [Checksum] = @AccountCheckSum ,
                            [TranCount] = [TranCount] + 1 ,
                            [ModifyVersion] = [ModifyVersion] + 1 ,
                            [Status] = @Status ,
                            [LastTranOn] = @LastTranOn ,
                            [ActiveTo] = @ActiveTo
			  --,[ActivatedOn] = @LastTranOn
                    WHERE   [AccountNumber] = @AccountNumber
                            AND [ModifyVersion] = @ModifyVersion
                            AND [ProgramId] = @ProgramId
                END
            ELSE
                BEGIN
                    UPDATE  [dbo].[AccountHistory]
                    SET     [Checksum] = @AccountCheckSum ,
                            [TranCount] = [TranCount] + 1 ,
                            [ModifyVersion] = [ModifyVersion] + 1 ,
                            [Status] = @Status ,
                            [ActiveTo] = @ActiveTo ,
                            [LastTranOn] = @LastTranOn
			  --,[ActivatedOn] = @LastTranOn
                    WHERE   [AccountNumber] = @AccountNumber
                            AND [ModifyVersion] = @ModifyVersion
                            AND [ProgramId] = @ProgramId

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
                              [BalanceInitialized] ,
                              [PinCode]
                            )
                            SELECT  [AccountNumber] ,
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
                                    [BalanceInitialized] ,
                                    [PinCode]
                            FROM    [dbo].[AccountHistory]
                            WHERE   [AccountNumber] = @AccountNumber
                                    AND [ProgramId] = @ProgramId

                    DELETE  FROM [dbo].[AccountHistory]
                    WHERE   [AccountNumber] = @AccountNumber
                            AND [ProgramId] = @ProgramId
                END

            IF @@ROWCOUNT <> 0
                BEGIN
                    SET @IsSuccess = 1
                END
            ELSE
                BEGIN
                    SET @IsSuccess = 0
                END

			IF @IsSuccess = 1
			begin
            DECLARE @HostSsn VARCHAR(12) ,
                @ProgramCode VARCHAR(50)
            DECLARE @TranUtcDate VARCHAR(8)
            SET @HostSsn = NEXT VALUE FOR HostSsn_Sequence
            SET @HostSsn = RIGHT(REPLICATE('0', 9) + @HostSsn, 9)
            SELECT  @ProgramCode = [IdentityCode]
            FROM    [dbo].[Program]
            WHERE   [Id] = @ProgramId
            SET @TranUtcDate = SUBSTRING(CAST(@TranUtcDateTimeL AS VARCHAR(14)),
                                         1, 8)
			
			SET @TranCode = @ProgramCode + @MerchantCode + @TranUtcDate + @HostSsn

            INSERT  INTO [dbo].[TransactionBufferForBatch]
                    ( [AccountNumber] ,
                      [ProgramCode] ,
                      [MerchantCode] ,
                      [HostSSN] ,
                      [TerminalSSN] ,
                      [TranUtcDateTime] ,
                      [TranUtcDateTimeL] ,
                      [TranType] ,
                      [TranAmount] ,
                      [TranCode] ,
                      [TranGUID] ,
                      [ModifyVersion] ,
                      [BalanceAvailable] ,
                      [SecurityKeyId] ,
                      [Checksum] ,
                      [TranLocalDateTime] ,
                      [TranLocalDate] ,
                      [ResponseCode] ,
                      [TranRealDateTime] ,
                      [TranUtcDate] ,
                      [BatchTransactionDetailId]
                    )
            VALUES  ( @AccountNumber ,
                      @ProgramCode ,
                      @MerchantCode ,
                      @HostSsn ,
                      @TerminalSSN ,
                      @LastTranOn ,
                      @TranUtcDateTimeL ,
                      @TranType ,
                      @TranAmount ,
                      @TranCode ,
                      NEWID() ,
                      @ModifyVersion + 1 ,
                      @TranAmount ,
                      @SecurityKeyId ,
                      @Checksum ,
                      @TranLocalDateTime ,
                      @TranLocalDate ,
                      '0000' ,
                      @LastTranOn ,
                      CAST(@TranUtcDate AS INT) ,
                      @BatchTransactionDetailId
                    )
			 end
        END TRY
        BEGIN CATCH
            SET @IsSuccess = 0
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
    END
