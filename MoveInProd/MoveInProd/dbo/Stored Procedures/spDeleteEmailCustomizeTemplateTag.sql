CREATE PROCEDURE [dbo].[spDeleteEmailCustomizeTemplateTag]
@TagValueId INT
AS
BEGIN
	BEGIN TRY 
		BEGIN TRAN
			DELETE t1 FROM ProductEmailContentTagValueSet t1
			JOIN ProductEmailTemplateTagValue t2 
			ON t1.ProductEmailTemplateTagValueId = t2.Id
			WHERE t1.ProductEmailTemplateTagValueId = @TagValueId
			DELETE FROM ProductEmailTemplateTagValue 
			WHERE Id = @TagValueId
			COMMIT TRAN 
	END TRY	
	BEGIN CATCH
		ROLLBACK TRAN 
	END CATCH
END