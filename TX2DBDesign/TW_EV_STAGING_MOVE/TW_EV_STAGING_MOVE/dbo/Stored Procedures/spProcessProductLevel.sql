
CREATE PROCEDURE [dbo].[spProcessProductLevel]
	@BatchId INT,
	@UserName VARCHAR(50)
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM ProductLevelBatch WHERE Id = @BatchId)
		RETURN;
	
	IF NOT EXISTS(SELECT 1 FROM ProductLevelBatchDetail WHERE ProductLevelBatchId = @BatchId)
		RETURN;
	
	DECLARE @ProductId INT
	DECLARE @ProductVersionId INT
	DECLARE @Id BIGINT
	DECLARE @ProductCode VARCHAR(50)
	DECLARE @InstockHighWatermark INT
	DECLARE @ProcurementQty INT
	DECLARE @CacheHighWatermark INT
	DECLARE @CacheLowWatermark INT
	DECLARE @Reason NVARCHAR(100)
	DECLARE @ResponseCode VARCHAR(5)
	
	DECLARE @Status TINYINT = 1
	DECLARE @SuccessProductCount INT = 0
	DECLARE @FailProductCount INT = 0
	
	DECLARE @CurrentDateTime DATETIME = GETDATE()
	
	UPDATE ProductLevelBatch SET ExecuteStartTime = @CurrentDateTime WHERE Id = @BatchId
	
	DECLARE C CURSOR FOR
		SELECT Id, ProductCode, InstockHighWatermark, ProcurementQty, CacheHighWatermark, CacheLowWatermark, Reason, ResponseCode
		FROM ProductLevelBatchDetail
		WHERE ProductLevelBatchId = @BatchId
	
	OPEN C
	FETCH NEXT FROM C INTO @Id, @ProductCode, @InstockHighWatermark, @ProcurementQty, @CacheHighWatermark, @CacheLowWatermark, @Reason, @ResponseCode
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@ResponseCode IS NULL OR @ResponseCode = '')
		BEGIN
			BEGIN TRAN
			BEGIN TRY
				SELECT @ProductId = P.Id, @ProductVersionId = PV.Id
				FROM Product P INNER JOIN ProductVersion PV ON P.Id = PV.ProductId
				WHERE P.ProductCode = @ProductCode
				
				IF (@CacheHighWatermark IS NOT NULL)
				BEGIN
					UPDATE Product SET
						APICacheHW = @CacheHighWatermark
					WHERE Id = @ProductId
					
					UPDATE ProductVersion SET
						APICacheHW = @CacheHighWatermark
					WHERE Id = @ProductVersionId
				END
				
				IF (@CacheLowWatermark IS NOT NULL)
				BEGIN
					UPDATE Product SET
						APICacheLW = @CacheLowWatermark
					WHERE Id = @ProductId
					
					UPDATE ProductVersion SET
						APICacheLW = @CacheLowWatermark
					WHERE Id = @ProductVersionId
				END
				
				IF (@InstockHighWatermark IS NOT NULL)
				BEGIN
					IF EXISTS(SELECT 1 FROM ProductStat WHERE ProductId = @ProductId)
					BEGIN
						UPDATE ProductStat SET
							HighWatermark = @InstockHighWatermark,
							LastModifiedOn = @CurrentDateTime
						WHERE ProductId = @ProductId
					END
					ELSE
					BEGIN
						INSERT INTO ProductStat
							(ProductId, GeneratedQuantity, InStockQuantity, HighWatermark, LowWatermark, LastModifiedOn)
						VALUES
							(@ProductId, 0, 0, @InstockHighWatermark, 0, @CurrentDateTime)
					END
				END

				IF (@ProcurementQty IS NOT NULL)
				BEGIN
					IF EXISTS(SELECT 1 FROM ProductProcurementTriggerSetting WHERE Id = @ProductId)
					BEGIN
						UPDATE ProductProcurementTriggerSetting SET
							ProcurementQty = @ProcurementQty,
							ModifiedBy = @UserName,
							ModifiedOn = @CurrentDateTime
						WHERE Id = @ProductId
					END
					ELSE
					BEGIN
						INSERT INTO ProductProcurementTriggerSetting
							(Id, ProcurementQty, NeedProcurementTrigger, CreatedBy, CreatedOn)
						VALUES
							(@ProductId, @ProcurementQty, 0, @UserName, @CurrentDateTime)
					END
				END
				
				UPDATE ProductLevelBatchDetail SET Reason = 'Success', ResponseCode = '0000' WHERE Id = @Id
				
				COMMIT TRAN;
				
				SET @SuccessProductCount = @SuccessProductCount + 1
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN;
				
				UPDATE ProductLevelBatchDetail SET Reason = 'Error', ResponseCode = '9999' WHERE Id = @Id
				
				SET @FailProductCount = @FailProductCount + 1
				SET @Status = 2
			END CATCH
		END
		ELSE
		BEGIN
			SET @FailProductCount = @FailProductCount + 1
		END
		
		FETCH NEXT FROM C INTO @Id, @ProductCode, @InstockHighWatermark, @ProcurementQty, @CacheHighWatermark, @CacheLowWatermark, @Reason, @ResponseCode
	END
	
	CLOSE C
	DEALLOCATE C
	
	UPDATE ProductLevelBatch SET 
		Status = @Status, 
		ExecuteEndTime = GETDATE(), 
		SuccessProductCount = @SuccessProductCount, 
		FailProductCount = @FailProductCount
	WHERE Id = @BatchId
END
