
CREATE PROCEDURE [dbo].[sp_sync_product_external_property]
@RunId varchar(50)
AS
BEGIN
	UPDATE TXCProductSync
	SET TXCProductExternalPropertyId = TXCProductVersionId
	WHERE RunId = @RunId
	AND ISNULL(WalletImage, 0) <> 0 
	AND TXCProductExternalPropertyId IS NULL
	
	DECLARE @TXCProductExternalPropertyId INT
	DECLARE @TX2ProductExternalPropertyId INT
	
	BEGIN TRAN
	BEGIN TRY
		DECLARE C CURSOR FOR
		SELECT DISTINCT TXCProductExternalPropertyId FROM TXCProductSync WHERE RunId = @RunId AND TXCProductExternalPropertyId IS NOT NULL
		
		OPEN C;
		FETCH NEXT FROM C INTO @TXCProductExternalPropertyId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO ProductExternalProperty DEFAULT VALUES
			SET @TX2ProductExternalPropertyId = SCOPE_IDENTITY()
			
			INSERT INTO ProductExternalPropertySet (ProductExternalPropertyId, PropertyName, PropertyValue, Description)
			SELECT DISTINCT @TX2ProductExternalPropertyId, PropertyName, PropertyValue, Description
			FROM TXCProductExternalPropertySync
			WHERE RunId = @RunId AND TXCProductExternalPropertyId = @TXCProductExternalPropertyId
			
			UPDATE TXCProductSync SET ProductExternalPropertyId = @TX2ProductExternalPropertyId
			WHERE RunId = @RunId AND TXCProductExternalPropertyId = @TXCProductExternalPropertyId
			
			FETCH NEXT FROM C INTO @TXCProductExternalPropertyId
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
