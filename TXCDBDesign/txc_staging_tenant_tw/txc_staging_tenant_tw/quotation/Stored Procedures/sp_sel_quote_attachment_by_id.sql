CREATE PROCEDURE [quotation].[sp_sel_quote_attachment_by_id]
	-- Add the parameters for the stored procedure here
	@QuotationAttachementId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		id "QuoteAttachementId",
		upload_file_type "UploadFileType",
		file_name "FileName",
		uploader "Uploader",
		uploaded_on "UploadedOn",
		file_content_type "ContentType",
		account "Account",
		keyword "Keyword"
	FROM quotation.tb_qa_quotation_attachment
	WHERE id = @QuotationAttachementId
END