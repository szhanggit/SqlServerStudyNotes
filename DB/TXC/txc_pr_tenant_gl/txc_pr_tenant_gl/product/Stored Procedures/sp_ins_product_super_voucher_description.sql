CREATE PROCEDURE [product].[sp_ins_product_super_voucher_description]
	@product_id int,
	@description_content nvarchar(max),
	@created_by nvarchar(250),
	@created_on datetime,
	@error_message varchar(100) = NULL OUTPUT
AS
BEGIN
	BEGIN TRY
	IF EXISTS (SELECT 1 FROM product.tb_p_product_super_voucher_description WHERE product_id = @product_id)
		SET @error_message = 'Super voucher description is exist';
	ELSE
	BEGIN
	BEGIN TRANSACTION;
		INSERT INTO [product].[tb_p_product_super_voucher_description]
			([product_id], [description_content], [version], [created_by], [created_on])
		VALUES (@product_id, @description_content, 1, @created_by, @created_on);
		COMMIT TRANSACTION;
		SELECT SCOPE_IDENTITY();
	END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION;
		END;
		THROW;
	END CATCH;
END