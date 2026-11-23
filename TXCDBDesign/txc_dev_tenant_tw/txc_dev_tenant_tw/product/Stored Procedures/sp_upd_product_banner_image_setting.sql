CREATE PROCEDURE [product].[sp_upd_product_banner_image_setting]
	@product_id int,
	@hex_color nvarchar(10),
	@font_size int,
	@point_x decimal(6,2),
	@point_y decimal(6,2),
	@updated_by varchar(250),
	@updated_on datetime,
	@error_message varchar(100) = NULL OUTPUT
AS
BEGIN
	BEGIN TRY
		DECLARE @product_banner_image_setting_id int;
		SET @product_banner_image_setting_id = (SELECT TOP 1 ISNULL(product_banner_image_setting_id, 0) FROM product.tb_p_product_banner_image_setting WHERE product_id = @product_id ORDER BY product_banner_image_setting_id DESC)
		
		BEGIN TRANSACTION;
		
		IF @product_banner_image_setting_id >= 0
		BEGIN
			UPDATE [product].[tb_p_product_banner_image_setting]
			SET [hex_color] = @hex_color,
				[font_size] = @font_size,
				[point_x] = @point_x,
				[point_y] = @point_y,
				[last_updated_by] = @updated_by,
				[last_updated_on] = @updated_on
			WHERE product_banner_image_setting_id = @product_banner_image_setting_id;
		END
		ELSE
		BEGIN
			INSERT INTO [product].[tb_p_product_banner_image_setting]
				([product_id], [hex_color], [font_size], [point_x], [point_y], [created_by], [created_on])
			VALUES(@product_id, @hex_color, @font_size, @point_x, @point_y, @updated_by, @updated_on);
			
			SET @product_banner_image_setting_id = SCOPE_IDENTITY();
		END
		
		COMMIT TRANSACTION;
		
		SELECT @product_banner_image_setting_id;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT  > 0
		BEGIN
			ROLLBACK TRANSACTION
		END;
		THROW;
	END CATCH;
END