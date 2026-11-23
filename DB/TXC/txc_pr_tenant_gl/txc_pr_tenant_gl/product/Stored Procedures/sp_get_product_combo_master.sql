CREATE PROCEDURE [product].[sp_get_product_combo_master]
	@product_id INT
AS
BEGIN
	SELECT
		c.product_combo_id ProductComboId,
		c.product_id MasterProductId,
		mp.product_code MasterProductCode,
		mp.product_name MasterProductName,
		c.[Sequence],
		c.[Status],
		c.created_by CreatedBy,
		c.created_on CreatedOn,
		c.last_updated_by LastUpdatedBy,
		c.last_updated_on LastUpdatedOn
	FROM product.tb_p_product_combo c
	JOIN product.tb_p_product mp ON mp.product_id = c.product_id
	WHERE child_product_id = @product_id;
END