
CREATE PROCEDURE [dbo].[spArchiveTransaction_TW]
    @TaskId BIGINT ,
    @ArchiveStep BIGINT,
	@TotalCount INT OUT
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
		
		--If exists no process data, do nothing.
		SET @TotalCount = 0
		IF EXISTS ( SELECT 1 FROM dbo.TransactionArchiveSendBuffer) return

        DECLARE @LastArchivedDataEndId BIGINT
        DECLARE @ArchiveTaskLogId BIGINT
	
        SET @ArchiveTaskLogId = 0
	
        SELECT  @LastArchivedDataEndId = ISNULL(ArchivedDataEndId, 0)
        FROM    dbo.ArchiveTask
        WHERE   Id = @TaskId

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

		INSERT INTO [dbo].[ArchiveMoitor]([ArchiveTaskLogId],[ArchiveStep],[StepTime])VALUES(@ArchiveTaskLogId,0,GETDATE())

		--Check main table schema is same as archive table.
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
		--Check end
	
        IF @ArchiveTaskLogId != 0
            BEGIN

				INSERT INTO [dbo].[ArchiveMoitor]([ArchiveTaskLogId],[ArchiveStep],[StepTime])VALUES(@ArchiveTaskLogId,1,GETDATE())
				--Extract Data to buffer table.
                EXECUTE [dbo].[spArchiveTransactionExtractData_TW] @ArchiveTaskLogId, @ArchiveStep
		
				INSERT INTO [dbo].[ArchiveMoitor]([ArchiveTaskLogId],[ArchiveStep],[StepTime])VALUES(@ArchiveTaskLogId,2,GETDATE())
				--Sync data from buffer table to backup db's buffer table.
                EXECUTE [dbo].[spArchiveTransactionSyncData_TW] @ArchiveTaskLogId
		
				INSERT INTO [dbo].[ArchiveMoitor]([ArchiveTaskLogId],[ArchiveStep],[StepTime])VALUES(@ArchiveTaskLogId,3,GETDATE())
				--Archive data from backup db's buffer table to backup db's mail table. 
                EXECUTE [dbo].[spArchiveTransactionArchiveData_TW] @ArchiveTaskLogId
						
				INSERT INTO [dbo].[ArchiveMoitor]([ArchiveTaskLogId],[ArchiveStep],[StepTime])VALUES(@ArchiveTaskLogId,4,GETDATE())			
				--Delete backup database buffer data.
                EXECUTE [dbo].[spArchiveTransactionDeleteData_TW] @ArchiveTaskLogId
				
				INSERT INTO [dbo].[ArchiveMoitor]([ArchiveTaskLogId],[ArchiveStep],[StepTime])VALUES(@ArchiveTaskLogId,5,GETDATE())					
			    SELECT @TotalCount = DataCount FROM ArchiveTaskLog WITH(NOLOCK) WHERE Id = @ArchiveTaskLogId

				RETURN @TotalCount
            END
    END
