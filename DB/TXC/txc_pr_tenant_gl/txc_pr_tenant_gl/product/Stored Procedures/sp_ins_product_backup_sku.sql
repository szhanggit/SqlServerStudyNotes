CREATE PROCEDURE [product].[sp_ins_product_backup_sku]
		 @product_id int
		 ,@UserName nvarchar(250) 
		 ,@BackupSKUList [product].[product_backup_sku_type] Readonly
		 ,@Result int output
AS
BEGIN
	SET XACT_ABORT ON;

	BEGIN TRY

		BEGIN TRANSACTION;

		DECLARE @currentDateTime DATETIME = GETUTCDATE();

		if exists(select * from [product].[tb_p_product_backup_sku] with(nolock) where product_id = @product_id)
		begin
			delete from [product].[tb_p_product_backup_sku] where product_id = @product_id
		end

		insert into [product].[tb_p_product_backup_sku] (product_id, sku_id, back_sequence, created_by, created_on)
		select product_id, sku_id, back_sequence, @UserName as created_by, @currentDateTime as created_on from @BackupSKUList

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
END