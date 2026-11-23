CREATE PROCEDURE product.sp_update_product_wizard
 @WizardKey NVARCHAR(50),
 @WizardStep INT,
 @Content NVARCHAR(MAX),
 @Modifier NVARCHAR(30)
AS
BEGIN 
	UPDATE product.tb_p_product_wizard SET content = @Content, modifier = @Modifier, update_time = GETDATE() WHERE wizard_key = @WizardKey AND wizard_step = @WizardStep
END