

CREATE PROCEDURE [dbo].[spArchiveTransactionDeleteData_TW]
    @ArchiveTaskLogId BIGINT 
AS
    BEGIN
		-- ******************************************************
		-- Change archive database name for different environment
		-- Current: TW_EV_DBS_MOVEARCH
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
	
        IF ( SELECT [Status]
             FROM   ArchiveTaskLog
             WHERE  Id = @ArchiveTaskLogId
           ) <> 4
            RETURN
	
        DECLARE @DataCount INT
        DECLARE @CheckCount INT
        DECLARE @ArchivedDataEndId BIGINT
	
        BEGIN TRAN
        BEGIN TRY
            SELECT  @DataCount = ISNULL(DataCount, 0) ,
                    @ArchivedDataEndId = ISNULL(ArchivedDataEndId, 0)
            FROM    [dbo].[ArchiveTaskLog]
            WHERE   Id = @ArchiveTaskLogId
		
            SELECT  @CheckCount = COUNT(*)
            FROM    [dbo].[Transaction] AS T1 WITH ( NOLOCK )
                    INNER JOIN [dbo].[TransactionArchiveSendBuffer] AS T2 ON T1.Id = T2.Id
                    INNER JOIN [TW_EV_UAT_MOVEARCH].[dbo].[TransactionArchive] AS T3 ON T1.Id = T3.Id
		
            IF ( @DataCount = @CheckCount )
                BEGIN

					DELETE  [dbo].[TransactionFee]
					FROM    [dbo].[TransactionFee] AS T1 WITH ( NOLOCK )
					INNER JOIN [dbo].[TransactionFeeArchiveSendBuffer] AS T2 WITH ( NOLOCK ) ON T1.Id = T2.Id
					INNER JOIN dbo.TransactionArchiveSendBuffer AS t3 WITH ( NOLOCK ) ON t3.Id = t2.TransactionId
			
					-- Delete tansaction mail table data.
					DELETE  [dbo].[Transaction]
					FROM    [dbo].[Transaction] AS T1 WITH ( NOLOCK )
					INNER JOIN [dbo].[TransactionArchiveSendBuffer] AS T2 WITH ( NOLOCK ) ON T1.Id = T2.Id

					-- Delete tansaction fee buffer table data.
					TRUNCATE TABLE [dbo].[TransactionFeeArchiveSendBuffer]

					-- Delete tansaction buffer table data.
					TRUNCATE TABLE [TransactionArchiveSendBuffer]

                    TRUNCATE TABLE [TW_EV_UAT_MOVEARCH].[dbo].[TransactionArchiveReceiveBuffer]
                    TRUNCATE TABLE [TW_EV_UAT_MOVEARCH].[dbo].[TransactionFeeArchiveReceiveBuffer]
			
                    UPDATE  [dbo].[ArchiveTaskLog]
                    SET     [Status] = 5 ,
                            ExecuteEndTime = GETDATE()
                    WHERE   Id = @ArchiveTaskLogId
			
                    UPDATE  t2
                    SET     LastExecuteStatus = 5 ,
                            LastExecuteEndTime = GETDATE() ,
                            LastExecuteDataCount = @DataCount ,
                            ArchivedDataEndId = @ArchivedDataEndId
                    FROM    dbo.ArchiveTaskLog AS t1
                            JOIN dbo.ArchiveTask AS t2 ON t2.Id = t1.TaskId
                    WHERE   t1.id = @ArchiveTaskLogId

                END

            COMMIT TRAN;
        END TRY
        BEGIN CATCH
            ROLLBACK TRAN; 
		
            UPDATE  [dbo].[ArchiveTaskLog]
            SET     [Comment] = ERROR_MESSAGE()
            WHERE   Id = @ArchiveTaskLogId
        END CATCH
    END

