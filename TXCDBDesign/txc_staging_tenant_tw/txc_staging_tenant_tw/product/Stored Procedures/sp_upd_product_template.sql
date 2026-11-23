CREATE PROCEDURE [product].[sp_upd_product_template]

	-- Add the parameters for the stored procedure here
	@TemplateTags product.ProductTemplateTags READONLY,
	@TemplateVersionId int,
	@TemplateType int,
	@ProductId int,
	@Result int output
	
AS
begin  

	SET XACT_ABORT ON;
	BEGIN TRY	
	BEGIN TRANSACTION;    
		DECLARE @tb_p_product_template_tag_value_id int, 
			@tb_p_product_template_version_id int,
			@productTemplateId int
			
		-- step 1: insert new product.tb_p_product_template_tag_value
			INSERT INTO product.tb_p_product_template_tag_value DEFAULT VALUES;
			select @tb_p_product_template_tag_value_id = SCOPE_IDENTITY()
			
		-- step 2: insert tags in product.tb_p_product_template_tag_value_set	
			INSERT INTO product.tb_p_product_template_tag_value_set ([product_template_tag_value_id], [tag_id], [value], [text_value]) 
			SELECT @tb_p_product_template_tag_value_id, tag_id, [value], text_value from @TemplateTags
			
		-- step 3: insert new product.tb_p_product_template_version
			INSERT INTO product.tb_p_product_template_version ([template_version_id],[product_template_tag_value_id])
			SELECT @TemplateVersionId, @tb_p_product_template_tag_value_id
			select @tb_p_product_template_version_id = SCOPE_IDENTITY()


		-- step 4.1: get template_id given product_id
			SELECT @productTemplateId = template_id from product.tb_p_product with(nolock) where product_id = @ProductId
			IF (@productTemplateId <= 0 or @productTemplateId is null)
				BEGIN
					INSERT INTO product.tb_p_product_template DEFAULT VALUES;
					select @productTemplateId = SCOPE_IDENTITY()
					
					UPDATE product.tb_p_product SET template_id = @productTemplateId where product_id = @ProductId

					INSERT INTO [product].[tb_p_product_template_set] (product_template_id, template_type, product_template_version_id)
					SELECT @productTemplateId, @TemplateType, @tb_p_product_template_version_id
				END
			ELSE IF EXISTS (SELECT 1 FROM [product].[tb_p_product_template_set] WITH(NOLOCK) WHERE product_template_id = @productTemplateId AND template_type = @TemplateType)
				BEGIN -- step 4.2: update product.tb_p_product_template_set
					UPDATE [product].[tb_p_product_template_set] SET product_template_version_id = @tb_p_product_template_version_id
					WHERE product_template_id = @productTemplateId AND template_type = @TemplateType
				END
			ELSE
				BEGIN
					INSERT INTO [product].[tb_p_product_template_set] (product_template_id, template_type, product_template_version_id)
					SELECT @productTemplateId, @TemplateType, @tb_p_product_template_version_id
				END		

	set @Result = 1;
	COMMIT TRANSACTION;

	SELECT @@ROWCOUNT;

	END TRY
	BEGIN CATCH 
		set @Result = -1;
		IF @@TRANCOUNT  > 0
		BEGIN
			ROLLBACK TRANSACTION		  
		END;

		THROW;
    END CATCH;

    SET NOCOUNT, XACT_ABORT OFF;
end