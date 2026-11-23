CREATE PROCEDURE product.sp_create_product_wizard
 @Content1 NVARCHAR(max) = NULL,
 @Content2 NVARCHAR(max) = NULL,
 @Content3 NVARCHAR(max) = NULL,
 @Content4 NVARCHAR(max) = NULL,
 @Content5 NVARCHAR(max) = NULL,
 @Modifier NVARCHAR(30)
AS
BEGIN 
	BEGIN TRAN
	BEGIN TRY
		DECLARE @wizardkey NVARCHAR(40) = CONVERT(NVARCHAR(40), NEWID());

		INSERT product.tb_p_product_wizard(wizard_key, wizard_step, content, modifier, create_time, update_time)
			VALUES(@wizardkey, 1, @Content1, @Modifier, GETDATE(), GETDATE())
		INSERT product.tb_p_product_wizard(wizard_key, wizard_step, content, modifier, create_time, update_time)
			VALUES(@wizardkey, 2, @Content2, @Modifier, GETDATE(), GETDATE())
		INSERT product.tb_p_product_wizard(wizard_key, wizard_step, content, modifier, create_time, update_time)
			VALUES(@wizardkey, 3, @Content3, @Modifier, GETDATE(), GETDATE())
		INSERT product.tb_p_product_wizard(wizard_key, wizard_step, content, modifier, create_time, update_time)
			VALUES(@wizardkey, 4, @Content4, @Modifier, GETDATE(), GETDATE())
		INSERT product.tb_p_product_wizard(wizard_key, wizard_step, content, modifier, create_time, update_time)
			VALUES(@wizardkey, 5, @Content5, @Modifier, GETDATE(), GETDATE())
		SELECT @wizardkey;
		COMMIT;
	END TRY
	BEGIN CATCH
		ROLLBACK;
		SELECT '';
	END CATCH
END