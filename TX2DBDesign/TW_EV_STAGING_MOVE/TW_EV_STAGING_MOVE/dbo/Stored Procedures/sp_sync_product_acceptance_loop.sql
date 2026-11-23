
CREATE PROCEDURE [dbo].[sp_sync_product_acceptance_loop]
@RunId varchar(50)
AS
BEGIN
	UPDATE TXCProductAcceptanceLoopSync SET TX2MerchantId = M.TX2MerchantId
	FROM TXCMerchantMapping M
	WHERE TXCProductAcceptanceLoopSync.TXCMerchantId = M.TXCMerchantId
	AND RunId = @RunId

	UPDATE TXCProductAcceptanceLoopSync SET TX2ShopId = M.TX2ShopId
	FROM TXCShopMapping M
	WHERE TXCProductAcceptanceLoopSync.TXCShopId = M.TXCShopId
	AND RunId = @RunId
	
	IF EXISTS (SELECT TOP 1 1 FROM TXCProductAcceptanceLoopSync WHERE RunId = @RunId AND TX2MerchantId IS NULL)
		THROW 99999, 'Acceptance Loop Merchant Mapping Error', 1
	ELSE IF EXISTS (SELECT TOP 1 1 FROM TXCProductAcceptanceLoopSync WHERE RunId = @RunId AND TXCShopId IS NOT NULL AND TX2ShopId IS NULL)
		THROW 99999, 'Acceptance Loop Shop Mapping Error', 1
	
	DECLARE @TXCProductId INT
	DECLARE @TXCAcceptanceLoopId INT
	DECLARE @TX2AcceptanceLoopId INT
	DECLARE @TX2AcceptanceLoopMerchantId INT
	DECLARE @TXCMerchantId INT
	DECLARE @TX2MerchantId INT
	DECLARE @IsMultiBrand BIT
	
	BEGIN TRAN
	BEGIN TRY
		DECLARE C CURSOR FOR
		SELECT DISTINCT TXCProductId, TXCProductAcceptanceLoopId FROM TXCProductSync WHERE RunId = @RunId AND TXCProductAcceptanceLoopId IS NOT NULL
		
		OPEN C;
		FETCH NEXT FROM C INTO @TXCProductId, @TXCAcceptanceLoopId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO AcceptanceLoop DEFAULT VALUES
			SET @TX2AcceptanceLoopId = SCOPE_IDENTITY()
			
			DECLARE INNER_CURSOR CURSOR FOR
			SELECT DISTINCT TXCMerchantId, TX2MerchantId FROM TXCProductAcceptanceLoopSync WHERE RunId = @RunId AND TXCProductAcceptanceLoopId = @TXCAcceptanceLoopId
			
			OPEN INNER_CURSOR;
			FETCH NEXT FROM INNER_CURSOR INTO @TXCMerchantId, @TX2MerchantId
			WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO AcceptanceLoopMerchant (AcceptanceLoopId, MerchantId)
				VALUES (@TX2AcceptanceLoopId, @TX2MerchantId)
				
				SET @TX2AcceptanceLoopMerchantId = SCOPE_IDENTITY()
				
				INSERT INTO AcceptanceLoopShop (AcceptanceLoopMerchantId, ShopId)
				SELECT DISTINCT @TX2AcceptanceLoopMerchantId, TX2ShopId
				FROM TXCProductAcceptanceLoopSync
				WHERE RunId = @RunId
				AND TXCProductAcceptanceLoopId = @TXCAcceptanceLoopId
				AND TXCMerchantId = @TXCMerchantId
				AND TXCShopId IS NOT NULL
				
				FETCH NEXT FROM INNER_CURSOR INTO @TXCMerchantId, @TX2MerchantId
			END
			
			CLOSE INNER_CURSOR
			DEALLOCATE INNER_CURSOR
			
			SET @IsMultiBrand = 0
			IF (SELECT COUNT(DISTINCT TXCMerchantId) FROM TXCProductAcceptanceLoopSync WHERE RunId = @RunId AND TXCProductAcceptanceLoopId = @TXCAcceptanceLoopId) > 1
				SET @IsMultiBrand = 1
			
			UPDATE TXCProductSync SET ProductAcceptanceLoopId = @TX2AcceptanceLoopId, IsMultiBrand = @IsMultiBrand
			WHERE RunId = @RunId AND TXCProductId = @TXcProductId AND TXCProductAcceptanceLoopId = @TXCAcceptanceLoopId
			
			FETCH NEXT FROM C INTO @TXCProductId, @TXCAcceptanceLoopId
		END
		
		CLOSE C
		DEALLOCATE C
		
		COMMIT TRAN;
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		THROW;
	END CATCH
END
