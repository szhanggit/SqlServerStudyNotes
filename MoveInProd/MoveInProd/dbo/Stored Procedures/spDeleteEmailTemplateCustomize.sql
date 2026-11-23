CREATE PROCEDURE [dbo].[spDeleteEmailTemplateCustomize]
@ProductCustomizedEmailTemplateVersionSetId INT
AS
DECLARE 
@ProductCustomizedEmailTemplateVersionId INT,
@EmailTemplateTagValueId INT

BEGIN
	BEGIN TRY 
		BEGIN TRAN
			SET @ProductCustomizedEmailTemplateVersionId = (SELECT ProductCustomizedEmailTemplateVersionId FROM ProductCustomizedEmailTemplateVersionSet
			WHERE id = @ProductCustomizedEmailTemplateVersionSetId)
			SET @EmailTemplateTagValueId = (SELECT EmailTemplateTagValueId FROM ProductCustomizedEmailTemplateVersionSet
			WHERE id = @ProductCustomizedEmailTemplateVersionSetId)
			--删除模板
			DELETE FROM ProductCustomizedEmailTemplateVersionSet WHERE Id = @ProductCustomizedEmailTemplateVersionSetId
			--删除标签
			DELETE FROM ProductEmailContentTagValueSet WHERE ProductEmailTemplateTagValueId = @EmailTemplateTagValueId
			DELETE FROM ProductEmailTemplateTagValue WHERE Id = @EmailTemplateTagValueId
			--重置Product
			--UPDATE Product SET ProductCustomizedEmailTemplateVersionId = Null WHERE ProductCustomizedEmailTemplateVersionId = @ProductCustomizedEmailTemplateVersionId
		COMMIT TRAN 
	END TRY
	BEGIN CATCH
	select Error_number() as ErrorNumber,  --错误代码
           Error_severity() as ErrorSeverity,  --错误严重级别，级别小于10 try catch 捕获不到
           Error_state() as ErrorState ,  --错误状态码
           Error_Procedure() as ErrorProcedure , --出现错误的存储过程或触发器的名称。
           Error_line() as ErrorLine,  --发生错误的行号
           Error_message() as ErrorMessage  --错误的具体信息
		ROLLBACK TRAN 
	END CATCH
END
