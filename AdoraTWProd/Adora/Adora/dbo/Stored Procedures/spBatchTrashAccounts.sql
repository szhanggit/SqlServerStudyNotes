CREATE PROC [dbo].[spBatchTrashAccounts] @SessionId VARCHAR(50), 
                                         @IsSuccess BIT OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @rowCount INT;
        BEGIN TRY
            BEGIN TRAN;

            --insert new Transaction
            INSERT INTO [dbo].[Transaction]
            (AccountNumber, 
             ProgramCode, 
             TerminalSSN, 
             MerchantCode, 
             TranUtcDate, 
             TranUtcDateTime, 
             TranUtcDateTimeL, 
             TranLocalDateTime, 
             TranAmount, 
             SecurityKeyId, 
             [Status], 
             HostSSN, 
             RefundedAmount, 
             BalanceAvailable, 
             BalanceFrozen, 
             ResponseCode, 
             TranType, 
             CallerIP, 
             Channel, 
             TranLocalDate, 
             TranCode, 
             TranCodeRef, 
             TranRealDateTime, 
             [Checksum], 
			 ModifyVersion,
             TranGUID
            )
                   SELECT AccountNumber, 
                          ProgramCode, 
                          TerminalSSN, 
                          MerchantCode, 
                          TranUtcDate, 
                          TranUtcDateTime, 
                          TranUtcDateTimeL, 
                          TranLocalDateTime, 
                          TranAmount, 
                          SecurityKeyId, 
                          [TransactionStatus], 
                          HostSSN, 
                          RefundedAmount, 
                          BalanceAvailable, 
                          BalanceFrozen, 
                          ResponseCode, 
                          TranType, 
                          CallerIP, 
                          Channel, 
                          TranLocalDate, 
                          TranCode, 
                          TranCodeRef, 
                          TranUtcDateTime, 
                          TransactionChecksum, 
						  1,
                          NEWID()
                   FROM dbo.BUF_BatchTrash buf WITH(NOLOCK)
                   WHERE buf.SessionId = @SessionId;
            SELECT @rowCount =
            (
                SELECT COUNT(*)
                FROM
                (
                    SELECT DISTINCT 
                           [AccountNumber], 
                           [ProgramId]
                    FROM [BUF_BatchTrash] buf WITH(NOLOCK)
                    WHERE buf.SessionId = @SessionId
                ) AS t
            );

            --update Reverse Transaction History
            UPDATE t
              SET 
                  t.[Checksum] = buf.RedeemedTranChecksum, 
                  t.[RefundedAmount] = t.TranAmount, 
				  t.[ModifyVersion] = t.ModifyVersion + 1, 
                  t.[Status] = 2
            FROM dbo.[TransactionHistory] t
                 JOIN dbo.BUF_BatchTrash buf WITH(NOLOCK) ON t.AccountNumber = buf.AccountNumber
                                                             AND t.ProgramCode = buf.ProgramCode
            WHERE buf.SessionId = @SessionId
                  AND buf.IsTranHistory = 1
                  AND t.TranType = 101;

            --update reverse Transaction
            UPDATE t
              SET 
                  t.[Checksum] = buf.RedeemedTranChecksum, 
                  t.[RefundedAmount] = t.TranAmount, 
				  t.[ModifyVersion] = t.ModifyVersion + 1, 
                  t.[Status] = 2
            FROM dbo.[Transaction] t
                 JOIN dbo.BUF_BatchTrash buf WITH(NOLOCK) ON t.AccountNumber = buf.AccountNumber
                                                             AND t.ProgramCode = buf.ProgramCode
															 AND t.TranCode = buf.TranCodeRef
            WHERE buf.SessionId = @SessionId
                  AND buf.IsTranHistory = 0
                  AND t.TranType = 101;

            --update account History
            UPDATE a
              SET 
                  [Checksum] = buf.AccountCheckSum, 
                  [TranCount] = a.TranCount + 1, 
                  [ModifyVersion] = a.ModifyVersion + 1, 
                  [Status] = 8, 
                  [LastTranOn] = buf.TranUtcDateTime
            FROM dbo.AccountHistory a
                 JOIN dbo.BUF_BatchTrash buf ON a.AccountNumber = buf.AccountNumber
                                                AND a.ProgramId = buf.ProgramId
                                                AND a.ModifyVersion = buf.ModifyVersion 
												AND (buf.TranType = 404 OR buf.TranType = 405)
            WHERE buf.SessionId = @SessionId
                  AND buf.IsAccountHistory = 1;
            SELECT @rowCount = @rowCount - @@ROWCOUNT;

            --update account
            UPDATE a
              SET 
                  [Checksum] = buf.AccountCheckSum, 
                  [TranCount] = a.TranCount + 1, 
                  [ModifyVersion] = a.ModifyVersion + 1, 
                  [Status] = 8, 
                  [LastTranOn] = buf.TranUtcDateTime
            FROM dbo.Account a
                 JOIN dbo.BUF_BatchTrash buf ON a.AccountNumber = buf.AccountNumber
                                                AND a.ProgramId = buf.ProgramId
                                                AND a.ModifyVersion = buf.ModifyVersion
												AND (buf.TranType = 404 OR buf.TranType = 405)
            WHERE buf.SessionId = @SessionId
                  AND buf.IsAccountHistory = 0;
            SELECT @rowCount = @rowCount - @@ROWCOUNT;

            DELETE dbo.BUF_BatchTrash WHERE SessionId = @SessionId;
            
        END TRY
        BEGIN CATCH
            SET @IsSuccess = 0;
            PRINT ERROR_MESSAGE();
            ROLLBACK TRANSACTION;

           -- DELETE dbo.BUF_BatchTrash WHERE SessionId = @SessionId;
        END CATCH;
        IF @@TRANCOUNT > 0
           AND @rowCount = 0
            BEGIN
                SET @IsSuccess = 1;
                COMMIT TRANSACTION;
        END;
            ELSE
            IF @@TRANCOUNT > 0
                BEGIN
                    ROLLBACK TRANSACTION;
            END;
    END;
