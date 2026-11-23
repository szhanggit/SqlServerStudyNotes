CREATE PROCEDURE [product].[sp_get_product_combo]
	@product_id INT
AS
BEGIN
	SELECT
		product_combo_id ProductComboId,
		product_id ProductId,
		child_product_id ChildProductId,
		child_product_version_id ChildProductVersionId,
		[sequence],
		status,
		created_by CreatedBy,
		created_on CreatedOn,
		last_updated_by LastUpdatedBy,
		last_updated_on LastUpdatedOn
	FROM product.tb_p_product_combo
	WHERE product_id = @product_id
END