
CREATE PROCEDURE [dbo].[sp_sync_product_redeem_time_restriction]
@RunId varchar(50)  
AS
BEGIN
	UPDATE TXCProductRedeemTimeRestrictionSync
	SET DayOfTheWeek = CASE WHEN DayOfTheWeek = 0 THEN 6 ELSE DayOfTheWeek - 1 END
	WHERE RunId = @RunId
	
	DECLARE @TXCProductRedeemTimeRestrictionId INT
	DECLARE @TX2ProductRedeemTimeRestrictionId INT
	
	BEGIN TRAN
	BEGIN TRY
		DECLARE C CURSOR FOR
		SELECT DISTINCT TXCProductRedeemTimeRestrictionId FROM TXCProductSync WHERE RunId = @RunId AND TXCProductRedeemTimeRestrictionId IS NOT NULL
		
		OPEN C;
		FETCH NEXT FROM C INTO @TXCProductRedeemTimeRestrictionId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO ProductRedeemTimeRestriction DEFAULT VALUES
			SET @TX2ProductRedeemTimeRestrictionId = SCOPE_IDENTITY()
			
			INSERT INTO ProductRedeemTimeRestrictionSet (ProductRedeemTimeRestrictionId, DayOfTheWeek, StartTime, EndTime)
			SELECT DISTINCT @TX2ProductRedeemTimeRestrictionId, DayOfTheWeek, StartTime, EndTime
			FROM TXCProductRedeemTimeRestrictionSync
			WHERE RunId = @RunId AND TXCProductRedeemTimeRestrictionId = @TXCProductRedeemTimeRestrictionId
			
			UPDATE TXCProductSync SET ProductRedeemTimeRestrictionId = @TX2ProductRedeemTimeRestrictionId
			WHERE RunId = @RunId AND TXCProductRedeemTimeRestrictionId = @TXCProductRedeemTimeRestrictionId
			
			FETCH NEXT FROM C INTO @TXCProductRedeemTimeRestrictionId
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
