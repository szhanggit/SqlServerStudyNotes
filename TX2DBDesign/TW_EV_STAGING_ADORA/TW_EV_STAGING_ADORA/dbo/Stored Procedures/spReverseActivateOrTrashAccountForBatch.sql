
CREATE PROCEDURE dbo.spReverseActivateOrTrashAccountForBatch
    @AccountNumber VARCHAR(50) ,
    @ProgramId INT ,
    @AccountCheckSum VARCHAR(50) ,
    @ModifyVersion INT ,
    @Status INT ,
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
    @CallerIp VARCHAR(50) = NULL ,
    @IsSuccess BIT OUTPUT ,
    @ActiveFrom DATETIME = NULL ,
    @BatchTransactionDetailId BIGINT,
	@TranCode varchar(50) output
AS
BEGIN
    SET NOCOUNT ON;

        BEGIN TRAN

        BEGIN TRY
			DECLARE @OutputTbl TABLE (TranCode varchar(50));
            UPDATE  [dbo].[Account]
            SET     [Checksum] = @AccountCheckSum ,
                    [TranCount] = [TranCount] + 1 ,
                    [ModifyVersion] = [ModifyVersion] + 1 ,
                    [Status] = @Status ,
                    [LastTranOn] = @LastTranOn ,
                    [ActiveFrom] = @ActiveFrom
            WHERE   [AccountNumber] = @AccountNumber
                    AND [ModifyVersion] = @ModifyVersion
                    AND [ProgramId] = @ProgramId

            IF @@ROWCOUNT <> 0
                BEGIN
                    DECLARE @HostSsn VARCHAR(12) ,
                        @ProgramCode VARCHAR(50)
                    DECLARE @TranUtcDate VARCHAR(8)
                    SET @HostSsn = NEXT VALUE FOR HostSsn_Sequence
                    SET @HostSsn = RIGHT(REPLICATE('0', 9) + @HostSsn, 9)
                    SELECT  @ProgramCode = [IdentityCode]
                    FROM    [dbo].[Program]
                    WHERE   [Id] = @ProgramId
                    SET @TranUtcDate = SUBSTRING(CAST(@TranUtcDateTimeL AS VARCHAR(14)), 1, 8);

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
                              [CallerIP] ,
                              [BatchTransactionDetailId]
                            )
					OUTPUT INSERTED.[TranCode] INTO @OutputTbl(TranCode)
                    VALUES  ( @AccountNumber ,
                              @ProgramCode ,
                              @MerchantCode ,
                              @HostSsn ,
                              @TerminalSSN ,
                              @LastTranOn ,
                              @TranUtcDateTimeL ,
                              @TranType ,
                              @TranAmount ,
                              @ProgramCode + @MerchantCode + @TranUtcDate
                              + @HostSsn ,
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
                              @CallerIp ,
                              @BatchTransactionDetailId
                            )
                    SET @IsSuccess = 1
                END
            ELSE
                BEGIN
                    SET @IsSuccess = 0
                END
		select @TranCode = TranCode from @OutputTbl;
	
        END TRY
        BEGIN CATCH
            SET @IsSuccess = 0
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
END


