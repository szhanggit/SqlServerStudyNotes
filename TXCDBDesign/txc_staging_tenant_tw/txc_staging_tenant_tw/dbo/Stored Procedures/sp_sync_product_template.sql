
CREATE PROCEDURE [dbo].[sp_sync_product_template]
@RunId varchar(50)
AS
BEGIN
	UPDATE TXCProductTemplateSync SET TX2TemplateVersionId = M.EmailTemplateVersionId
	FROM TXCEmailTemplateVersionMapping M
	WHERE TXCProductTemplateSync.TXCTemplateVersionId = M.ExternalId
	AND RunId = @RunId
	AND TemplateType = 1 AND TemplateSubType = 1
	
	UPDATE TXCProductTemplateSync SET TX2TemplateVersionId = M.SLMSTemplateVersionId
	FROM TXCSLMSTemplateVersionMapping M
	WHERE TXCProductTemplateSync.TXCTemplateVersionId = M.ExternalId
	AND RunId = @RunId
	AND TemplateType = 2 AND TemplateSubType = 2
	
	UPDATE TXCProductTemplateSync SET TX2MediaLibraryId = m.MediaLibraryId
	FROM ContentTag t, TXCMediaLibraryMapping m
	WHERE TXCProductTemplateSync.TagId = t.Id
	AND t.TagCategory = 3 AND t.TagType = 2
	AND TXCProductTemplateSync.Value = m.ExternalId
	AND RunId = @RunId
	
	DECLARE @TXCProductTemplateId INT
	DECLARE @TXCTemplateVersionId INT
	DECLARE @TX2TemplateVersionId INT
	DECLARE @ProductEmailTemplateVersionId INT
	DECLARE @ProductEmailTemplateTagValueId INT
	DECLARE @ProductSLMSTemplateVersionId INT
	DECLARE @ProductSLMSTemplateTagValueId INT
	
	BEGIN TRAN
	BEGIN TRY
		DECLARE C CURSOR FOR
		SELECT DISTINCT TXCProductTemplateId FROM TXCProductSync WHERE RunId = @RunId AND TXCProductTemplateId IS NOT NULL
		
		OPEN C;
		FETCH NEXT FROM C INTO @TXCProductTemplateId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Email Template
			IF EXISTS(SELECT 1 FROM TXCProductTemplateSync WHERE RunId = @RunId AND TXCProductTemplateId = @TXCProductTemplateId AND TemplateType = 1 AND TemplateSubType = 1)
			BEGIN
				INSERT INTO ProductEmailTemplateVersion DEFAULT VALUES
				SET @ProductEmailTemplateVersionId = SCOPE_IDENTITY()
				
				DECLARE EMAIL_CURSOR CURSOR FOR
				SELECT DISTINCT TXCTemplateVersionId, TX2TemplateVersionId FROM TXCProductTemplateSync WHERE RunId = @RunId AND TXCProductTemplateId = @TXCProductTemplateId AND TemplateType = 1 AND TemplateSubType = 1
				
				OPEN EMAIL_CURSOR;
				FETCH NEXT FROM EMAIL_CURSOR INTO @TXCTemplateVersionId, @TX2TemplateVersionId
				WHILE @@FETCH_STATUS = 0
				BEGIN
					IF EXISTS (SELECT 1 FROM TXCProductTemplateSync WHERE RunId = @RunId AND TXCProductTemplateId = @TXCProductTemplateId AND TXCTemplateVersionId = @TXCTemplateVersionId AND TagId IS NOT NULL)
					BEGIN
						INSERT INTO ProductEmailTemplateTagValue DEFAULT VALUES
						SET @ProductEmailTemplateTagValueId = SCOPE_IDENTITY()
						
						INSERT INTO ProductEmailContentTagValueSet (ContentTagId, ProductEmailTemplateTagValueId, Value, TextValue)
						SELECT TagId, @ProductEmailTemplateTagValueId, ISNULL(CONVERT(NVARCHAR(MAX), TX2MediaLibraryId), Value), TextValue
						FROM TXCProductTemplateSync WHERE RunId = @RunId AND TXCProductTemplateId = @TXCProductTemplateId AND TXCTemplateVersionId = @TXCTemplateVersionId AND TagId IS NOT NULL AND TagId <> 0
					END
					ELSE
					BEGIN
						SET @ProductEmailTemplateTagValueId = NULL
					END
					
					INSERT INTO ProductEmailTemplateVersionSet (ProductEmailTemplateVersionId, EmailTemplateVersionId, EmailTemplateTagValueId)
					VALUES (@ProductEmailTemplateVersionId, @TX2TemplateVersionId, @ProductEmailTemplateTagValueId)
					
					FETCH NEXT FROM EMAIL_CURSOR INTO @TXCTemplateVersionId, @TX2TemplateVersionId
				END
				
				CLOSE EMAIL_CURSOR
				DEALLOCATE EMAIL_CURSOR
				
				UPDATE TXCProductSync SET ProductEmailTemplateVersionId = @ProductEmailTemplateVersionId
				WHERE RunId = @RunId AND TXCProductTemplateId = @TXCProductTemplateId
			END
			
			-- SMS Template
			IF EXISTS(SELECT 1 FROM TXCProductTemplateSync WHERE RunId = @RunId AND TXCProductTemplateId = @TXCProductTemplateId AND TemplateType = 2 AND TemplateSubType = 2)
			BEGIN
				INSERT INTO ProductSLMSTemplateVersion DEFAULT VALUES
				SET @ProductSLMSTemplateVersionId = SCOPE_IDENTITY()
				
				DECLARE SMS_CURSOR CURSOR FOR
				SELECT DISTINCT TXCTemplateVersionId, TX2TemplateVersionId FROM TXCProductTemplateSync WHERE RunId = @RunId AND TXCProductTemplateId = @TXCProductTemplateId AND TemplateType = 2 AND TemplateSubType = 2
				
				OPEN SMS_CURSOR;
				FETCH NEXT FROM SMS_CURSOR INTO @TXCTemplateVersionId, @TX2TemplateVersionId
				WHILE @@FETCH_STATUS = 0
				BEGIN
					IF EXISTS (SELECT 1 FROM TXCProductTemplateSync WHERE RunId = @RunId AND TXCProductTemplateId = @TXCProductTemplateId AND TXCTemplateVersionId = @TXCTemplateVersionId AND TagId IS NOT NULL)
					BEGIN
						INSERT INTO ProductSLMSTemplateTagValue DEFAULT VALUES
						SET @ProductSLMSTemplateTagValueId = SCOPE_IDENTITY()
						
						INSERT INTO ProductSLMSContentTagValueSet (ContentTagId, ProductSLMSTemplateTagValueId, Value)
						SELECT TagId, @ProductSLMSTemplateTagValueId, Value
						FROM TXCProductTemplateSync WHERE RunId = @RunId AND TXCProductTemplateId = @TXCProductTemplateId AND TXCTemplateVersionId = @TXCTemplateVersionId AND TagId IS NOT NULL AND TagId <> 0
					END
					ELSE
					BEGIN
						SET @ProductSLMSTemplateTagValueId = NULL
					END
					
					INSERT INTO ProductSLMSTemplateVersionSet (ProductSLMSTemplateVersionId, SLMSTemplateVersionId, SLMSTemplateTagValueId)
					VALUES (@ProductSLMSTemplateVersionId, @TX2TemplateVersionId, @ProductSLMSTemplateTagValueId)
					
					FETCH NEXT FROM SMS_CURSOR INTO @TXCTemplateVersionId, @TX2TemplateVersionId
				END
				
				CLOSE SMS_CURSOR
				DEALLOCATE SMS_CURSOR
				
				UPDATE TXCProductSync SET ProductSLMSTemplateVersionId = @ProductSLMSTemplateVersionId
				WHERE RunId = @RunId AND TXCProductTemplateId = @TXCProductTemplateId
			END
			
			FETCH NEXT FROM C INTO @TXCProductTemplateId
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
