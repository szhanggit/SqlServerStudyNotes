
CREATE PROCEDURE [dbo].[sp_sync_product_redeem_date_blacklist]
@RunId varchar(50),
@TimeOffsetMinute int
AS
BEGIN
	UPDATE TXCProductRedeemDateBlacklistSync
	SET BlackDate = DATEADD(MINUTE, @TimeOffsetMinute, TXCBlackDate)
	WHERE RunId = @RunId
	
	DECLARE @TXCProductRedeemDateBlacklistId INT
	DECLARE @TX2ProductRedeemDateBlacklistId INT
	
	BEGIN TRAN
	BEGIN TRY
		DECLARE C CURSOR FOR
		SELECT DISTINCT TXCProductRedeemDateBlacklistId FROM TXCProductSync WHERE Runid = @RunId AND TXCProductRedeemDateBlacklistId IS NOT NULL
		
		OPEN C;
		FETCH NEXT FROM C INTO @TXCProductRedeemDateBlacklistId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO ProductRedeemDateBlacklist DEFAULT VALUES
			SET @TX2ProductRedeemDateBlacklistId = SCOPE_IDENTITY()
			
			INSERT INTO ProductRedeemDateBlacklistSet (ProductRedeemDateBlacklistId, BlackDate)
			SELECT DISTINCT @TX2ProductRedeemDateBlacklistId, BlackDate
			FROM TXCProductRedeemDateBlacklistSync
			WHERE RunId = @RunId AND TXCProductRedeemDateBlacklistId = @TXCProductRedeemDateBlacklistId
			
			UPDATE TXCProductSync SET ProductRedeemDateBlacklistId = @TX2ProductRedeemDateBlacklistId
			WHERE RunId = @RunId AND TXCProductRedeemDateBlacklistId = @TXCProductRedeemDateBlacklistId
			
			FETCH NEXT FROM C INTO @TXCProductRedeemDateBlacklistId
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
