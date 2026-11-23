CREATE PROCEDURE [product].[sp_upd_product_super_voucher_description]
	@product_id int,
	@description_content nvarchar(max),
	@created_by nvarchar(250),
	@created_on datetime,
	@error_message varchar(100) = NULL OUTPUT
AS
BEGIN
	DECLARE @max_version int;
	
	IF NOT EXISTS (SELECT 1 FROM product.tb_p_product_super_voucher_description WHERE product_id = @product_id)
		SET @max_version = 0
	ELSE
		SET @max_version = (SELECT MAX(version) FROM product.tb_p_product_super_voucher_description WHERE product_id = @product_id)
	
	INSERT INTO [product].[tb_p_product_super_voucher_description]
	([product_id], [description_content], [version], [created_by], [created_on])
	VALUES (@product_id, @description_content, @max_version + 1, @created_by, @created_on);

	SELECT SCOPE_IDENTITY()
END