CREATE PROCEDURE [product].[sp_select_productIdAndCode]
    @product_id int = 0,
	@product_code varchar(50) = null
AS
begin 
	IF @product_id > 0 AND len(@product_code) > 0
	BEGIN
		SELECT product_id AS productid, product_code AS productcode FROM product.tb_p_product with(nolock) WHERE product_id = @product_id AND product_code = @product_code;
	END
	ELSE
	BEGIN
		IF @product_id > 0
		BEGIN
			SELECT product_id AS productid, product_code AS productcode FROM product.tb_p_product with(nolock) WHERE product_id = @product_id;
		END
		ELSE
		BEGIN
			SELECT product_id AS productid, product_code AS productcode FROM product.tb_p_product with(nolock) WHERE product_code = @product_code;
		END
	END
end