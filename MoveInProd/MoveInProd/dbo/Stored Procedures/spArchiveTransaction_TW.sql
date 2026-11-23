

CREATE PROCEDURE [dbo].[spArchiveTransaction_TW]
    @TaskId BIGINT ,
    @ArchiveDate DATETIME = NULL ,
    @ArchiveConsumeDate DATETIME = NULL
AS
    BEGIN
	-- ******************************************************
	-- Change archive database name for different environment
	-- Current: TW_EV_DBS_MOVEARC
	-- ******************************************************
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

	--ArchiveTaskLog Status：
	--1.Initialized
	--2.Extracted
	--3.Synchronized
	--4.Archived
	--5.Finished
	
        DECLARE @LastExecuteStatus TINYINT
        DECLARE @LastArchiveTaskLogId BIGINT
        DECLARE @LastArchivedDataEndId BIGINT
        DECLARE @ArchiveTaskLogId BIGINT
	
        SET @ArchiveTaskLogId = 0
	
        IF @ArchiveDate IS NULL
            BEGIN
                SET @ArchiveDate = DATEADD(MM, -12,
                                           CONVERT(VARCHAR(20), GETDATE(), 112))
            END

			
        IF @ArchiveConsumeDate IS NULL
            BEGIN
                SET @ArchiveConsumeDate = DATEADD(MM, -6,
                                                  CONVERT(VARCHAR(20), GETDATE(), 112))
            END
	
        SELECT  @LastExecuteStatus = ISNULL(LastExecuteStatus, 0) ,
                @LastArchiveTaskLogId = ISNULL(LastExecuteLogId, 0) ,
                @LastArchivedDataEndId = ISNULL(ArchivedDataEndId, 0)
        FROM    dbo.ArchiveTask
        WHERE   Id = @TaskId

		-- recovery manually
        IF @LastExecuteStatus = 4
            BEGIN
                RETURN
            END
	
        --IF EXISTS ( SELECT  1
        --            FROM    [dbo].[Transaction] AS T1 WITH ( NOLOCK )
        --                    INNER JOIN [dbo].[Voucher] AS T2 WITH ( NOLOCK ) ON T1.AccountNumber = T2.VoucherNumber
        --                    INNER JOIN [dbo].[Program] AS T3 WITH ( NOLOCK ) ON T2.ProgramId = T3.Id
        --                                                      AND T3.IdentityCode = T1.ProgramCode
        --            WHERE   T2.ExpiryDate < @ArchiveDate )
        --    BEGIN

        WHILE NOT EXISTS ( SELECT   *
                           FROM     dbo.TransactionArchiveVoucherCutLine WITH ( NOLOCK )
                           WHERE    ExpiryDate = @ArchiveDate
                                    AND Status = 5
                                    AND DataCount = 0 )
            BEGIN
                WAITFOR DELAY '00:00:02'
								
				EXECUTE [dbo].[spArchiveTransactionDeleteTransaction_TW]

                BEGIN TRAN
                BEGIN TRY
                    INSERT  INTO [dbo].[ArchiveTaskLog]
                            ( TaskId ,
                              ExecuteStartTime ,
                              [Status] ,
                              LastExecuteArchivedDataEndId
			                )
                    VALUES  ( @TaskId ,
                              GETDATE() ,
                              1 ,
                              @LastArchivedDataEndId
			                )
			
                    SET @ArchiveTaskLogId = SCOPE_IDENTITY()
			
                    UPDATE  dbo.ArchiveTask
                    SET     LastExecuteStartTime = GETDATE() ,
                            LastExecuteLogId = @ArchiveTaskLogId ,
                            LastExecuteStatus = 1
                    WHERE   Id = @TaskId
			
                    COMMIT TRAN;
                END TRY
                BEGIN CATCH
                    ROLLBACK TRAN; 
                    SET @ArchiveTaskLogId = 0
                END CATCH
            --END
	
	-- COMPARE Transaction VS TransactionArchiveSendBuffer and TransactionFee VS TransactionFeeArchiveSendBuffer
                IF EXISTS ( SELECT  1
                            FROM    ( SELECT    name
                                      FROM      sys.columns
                                      WHERE     object_id = OBJECT_ID('Transaction')
                                    ) A
                                    FULL OUTER JOIN ( SELECT  name
                                                      FROM    sys.columns
                                                      WHERE   object_id = OBJECT_ID('TransactionArchiveSendBuffer')
                                                              AND name != 'Deleted'
                                                    ) B ON A.name = B.name
                            WHERE   A.name IS NULL
                                    OR B.name IS NULL )
                    OR EXISTS ( SELECT  1
                                FROM    ( SELECT    name
                                          FROM      sys.columns
                                          WHERE     object_id = OBJECT_ID('TransactionFee')
                                        ) A
                                        FULL OUTER JOIN ( SELECT
                                                              name
                                                          FROM
                                                              sys.columns
                                                          WHERE
                                                              object_id = OBJECT_ID('TransactionFeeArchiveSendBuffer')
                                                        ) B ON A.name = B.name
                                WHERE   A.name IS NULL
                                        OR B.name IS NULL )
                    BEGIN
                        UPDATE  ArchiveTaskLog
                        SET     Comment = 'Table schema not matched.'
                        WHERE   Id = @ArchiveTaskLogId
		
                        SET @ArchiveTaskLogId = 0
                    END
	
                IF @ArchiveTaskLogId != 0
                    BEGIN

                --TRUNCATE TABLE [dbo].[TransactionArchiveSendBuffer]
                --TRUNCATE TABLE [dbo].[TransactionFeeArchiveSendBuffer]
		
                        TRUNCATE TABLE [TW_EV_DBS_MOVEARC].[dbo].[TransactionArchiveReceiveBuffer]
                        TRUNCATE TABLE [TW_EV_DBS_MOVEARC].[dbo].[TransactionFeeArchiveReceiveBuffer]

              

                        EXECUTE [dbo].[spArchiveTransactionVoucherCutLine_TW] @ArchiveDate,
                            @ArchiveConsumeDate

                        IF EXISTS ( SELECT  *
                                    FROM    dbo.TransactionArchiveVoucherCutLine
                                            WITH ( NOLOCK )
                                    WHERE   ExpiryDate = @ArchiveDate
                                            AND Status = 1 )
                            BEGIN
		
                                EXECUTE [dbo].[spArchiveTransactionExtractData_TW] @ArchiveTaskLogId,
                                    @ArchiveDate, @ArchiveConsumeDate
		
                                EXECUTE [dbo].[spArchiveTransactionSyncData_TW] @ArchiveTaskLogId
		
                                EXECUTE [dbo].[spArchiveTransactionArchiveData_TW] @ArchiveTaskLogId
		
                                EXECUTE [dbo].[spArchiveTransactionDeleteData_TW] @ArchiveTaskLogId,
                                    @ArchiveDate
                            END
                    END
            END
    END

