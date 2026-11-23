CREATE PROCEDURE [dbo].[spInsertBatchExtendTransaction]
	 @BatchTransactionId bigint  
	 ,@BatchExtendId int
	 AS  
	BEGIN  
		INSERT INTO BatchExtendTransaction ([BatchExtendId], [BatchTransactionId])
		SELECT @BatchExtendId, @BatchTransactionId
	END