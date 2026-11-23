 
 -- ALTER TABLE TXCProductSync
	--ADD IsFixedExpiryPolicy bit not null default 0; 
  
 -- ALTER TABLE TXCProductPriceSync
 -- ALTER COLUMN cost numeric(15, 4) null;
 -- ALTER TABLE TXCProductPriceSync
 -- ALTER COLUMN costwithTAX numeric(15, 4) null;
  
	
	CREATE PROCEDURE [dbo].[sp_sync_product_expiry_scheme]
@RunId varchar(50),
@TimeOffsetMinute int
AS
BEGIN
	DECLARE @NoExpireDateId INT
	DECLARE @FixEndOfDayId INT
	DECLARE @TXCProductExpirySchemeId INT
	DECLARE @TX2ProductExpirySchemeId INT
	DECLARE @NoExpireDateUTC DATETIME
	DECLARE @IsFixedExpiryPolicy BIT
	
	SELECT @NoExpireDateId = EP.Id FROM ExpirationPolicy EP INNER JOIN Dictionary D ON EP.DisplayNameId = D.Id
	AND D.Name = 'NoExpireDate'
	SELECT @FixEndOfDayId = EP.Id FROM ExpirationPolicy EP INNER JOIN Dictionary D ON EP.DisplayNameId = D.Id
	AND D.Name = 'FixEndOfDay'
	
	SET @NoExpireDateUTC = '2999/12/31 23:59:59'
	SET @NoExpireDateUTC = DATEADD(MINUTE, @TimeOffsetMinute * -1, @NoExpireDateUTC)
		
	BEGIN TRAN
	BEGIN TRY
		DECLARE C CURSOR FOR
		SELECT DISTINCT TXCProductExpirySchemeId , IsFixedExpiryPolicy FROM TXCProductSync WHERE Runid = @RunId AND TXCProductExpirySchemeId IS NOT NULL
		
		OPEN C;
		FETCH NEXT FROM C INTO @TXCProductExpirySchemeId , @IsFixedExpiryPolicy
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF EXISTS (SELECT 1 FROM TXCProductExpirySchemeSync WHERE RunId = @RunId AND TXCProductExpirySchemeId = @TXCProductExpirySchemeId AND ExpirationPolicyId = @NoExpireDateId AND @IsFixedExpiryPolicy = 1)
			BEGIN
				IF NOT EXISTS (SELECT 1 FROM TXCProductExpirySchemeSync WHERE RunId = @RunId AND TXCProductExpirySchemeId = @TXCProductExpirySchemeId AND ExpirationPolicyId = @FixEndOfDayId)
					INSERT INTO TXCProductExpirySchemeSync (RunId, TXCProductExpirySchemeId, ExpirationPolicyId) VALUES (@RunId, @TXCProductExpirySchemeId, @FixEndOfDayId)
				
				UPDATE TXCProductSync SET ExpirationDate = @NoExpireDateUTC WHERE RunId = @RunId AND TXCProductExpirySchemeId = @TXCProductExpirySchemeId
				
				DELETE TXCProductExpirySchemeSync WHERE RunId = @RunId AND TXCProductExpirySchemeId = @TXCProductExpirySchemeId AND ExpirationPolicyId = @NoExpireDateId
			END
			
			INSERT INTO ProductExpiryScheme DEFAULT VALUES
			SET @TX2ProductExpirySchemeId = SCOPE_IDENTITY()
			
			INSERT INTO ProductExpirySchemeSet (ProductExpirySchemeId, ExpirationPolicyId)
			SELECT DISTINCT @TX2ProductExpirySchemeId, ExpirationPolicyId
			FROM TXCProductExpirySchemeSync
			WHERE RunId = @RunId AND TXCProductExpirySchemeId = @TXCProductExpirySchemeId
			
			UPDATE TXCProductSync SET ProductExpirySchemeId = @TX2ProductExpirySchemeId
			WHERE RunId = @RunId AND TXCProductExpirySchemeId = @TXCProductExpirySchemeId
			
			FETCH NEXT FROM C INTO @TXCProductExpirySchemeId , @IsFixedExpiryPolicy
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
