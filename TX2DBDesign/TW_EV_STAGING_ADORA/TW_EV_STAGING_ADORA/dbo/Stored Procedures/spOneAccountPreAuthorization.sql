
CREATE PROCEDURE spOneAccountPreAuthorization 
@AccountNumber VARCHAR(50),
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
@LastTranOn DATETIME
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        DECLARE @ResponseCode VARCHAR(5)
        DECLARE @rowCount INT

        BEGIN TRAN

        BEGIN TRY
            UPDATE  t1
            SET     [BalanceAvailable] = @BalanceAvailable ,
                    [BalanceFrozen] = @BalanceFrozen ,
                    [Checksum] = @AccountCheckSum ,
                    [ModifyVersion] = t1.[ModifyVersion] + 1 ,
                    [LastTranOn] = @LastTranOn
            FROM    [dbo].[Account] AS t1
            WHERE t1.AccountNumber = @AccountNumber AND t1.ProgramId = @ProgramId AND t1.ModifyVersion = @ModifyVersion

            SELECT  @rowCount = @@ROWCOUNT

            IF @rowCount = 1
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
