CREATE PROCEDURE product.sp_get_product_wizard
 @WizardKey NVARCHAR(50)
AS
BEGIN 
	SELECT product_wizard_id, wizard_key, wizard_step, content, modifier, create_time, update_time FROM product.tb_p_product_wizard WITH(NOLOCK) WHERE wizard_key = @WizardKey
END