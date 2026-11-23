CREATE PROCEDURE [quotation].[sp_ins_quotation_attachment]
	-- Add the parameters for the stored procedure here
	@QuotationAttachementId int output,
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,

	@QuotationId int,
	@UploadFileType int,
	@FileName nvarchar(250),
	@Uploader nvarchar(250),
	@Account nvarchar(250),
	@FileContentType nvarchar(250),
	@keyword nvarchar(250)

AS
BEGIN
	SET XACT_ABORT ON;

	BEGIN TRY
		BEGIN TRANSACTION;

			SET @QuotationAttachementId = 0;
			SET @IsSuccess = 0;
			SET @ErrorMessage = NULL;

			DECLARE @created_quotation_attach table (created_id int);

			INSERT INTO quotation.tb_qa_quotation_attachment
			(
				quotation_id,
				upload_file_type,
				file_name,
				uploader,
				uploaded_on,
				account,
				file_content_type,
				keyword
			)
			OUTPUT INSERTED.id INTO @created_quotation_attach
			VALUES 
			(
				@QuotationId,
				@UploadFileType,
				@FileName,
				@Uploader,
				GETDATE(),
				@Account,
				@FileContentType,
				@keyword
			)

		IF NOT EXISTS (SELECT * FROM @created_quotation_attach)
		BEGIN
			SET @ErrorMessage = 'failed to insert quotation attachment child';
			GOTO stop_process;
		END

		SELECT TOP 1 @QuotationAttachementId = created_id FROM @created_quotation_attach

	SET @IsSuccess = 1

	stop_process:

	IF @IsSuccess = 0
		BEGIN
			ROLLBACK TRANSACTION;
		END
	ELSE
		BEGIN
			COMMIT TRANSACTION;
		END
	END TRY
	BEGIN CATCH
       IF @@TRANCOUNT > 0
       BEGIN
          ROLLBACK TRANSACTION
       END;

		THROW
	END CATCH

	SET XACT_ABORT OFF;
END