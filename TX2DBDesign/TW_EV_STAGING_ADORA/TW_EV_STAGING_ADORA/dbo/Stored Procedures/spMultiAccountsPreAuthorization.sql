
CREATE PROCEDURE spMultiAccountsPreAuthorization @SessionId VARCHAR(50)
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
            SET     [BalanceAvailable] = t2.BalanceAvailable ,
                    [BalanceFrozen] = t2.BalanceFrozen ,
                    [Checksum] = t2.AccountCheckSum ,
                    [ModifyVersion] = t1.[ModifyVersion] + 1 ,
                    [LastTranOn] = t2.LastTranOn
            FROM    [dbo].[Account] AS t1
                    JOIN 
						(
							--find min balance item, means it do last
							SELECT * FROM 
								(SELECT *, ROW_NUMBER() OVER(PARTITION BY AccountNumber ORDER BY BalanceAvailable) rowNumber 
									FROM dbo.BUF_PreAuthorization WITH(NOLOCK) WHERE SessionId = @SessionId
								) t 
							WHERE t.rowNumber = 1
						) AS t2 ON t1.AccountNumber = t2.AccountNumber AND t1.ProgramId = t2.ProgramId AND t1.ModifyVersion = t2.ModifyVersion
            WHERE   t2.SessionId = @SessionId
            SELECT  @rowCount = @@ROWCOUNT
            IF @rowCount = ( SELECT COUNT(DISTINCT AccountNumber)
                             FROM   dbo.BUF_PreAuthorization WITH ( NOLOCK )
                             WHERE  SessionId = @SessionId
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
                            JOIN dbo.BUF_PreAuthorization AS t2 ON t1.AccountNumber = t2.AccountNumber
                                                              AND t1.TranCode = t2.TranCode
                    WHERE   SessionId = @SessionId
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
                        JOIN dbo.BUF_PreAuthorization AS t2 ON t1.AccountNumber = t2.AccountNumber
                                                              AND t1.TranCode = t2.TranCode
                WHERE   SessionId = @SessionId
            END

        DELETE  FROM dbo.BUF_PreAuthorization
        WHERE   SessionId = @SessionId

        SELECT  @ResponseCode;
    END
