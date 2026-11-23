CREATE PROCEDURE [product].[sp_sel_product_banner_image_setting]
	-- Add the parameters for the stored procedure here
    @product_id int,
	@error_message varchar(100) = NULL OUTPUT
AS
BEGIN
   select top 1 * from product.tb_p_product_banner_image_setting with(nolock) where product_id = @product_id order by product_banner_image_setting_id desc
END