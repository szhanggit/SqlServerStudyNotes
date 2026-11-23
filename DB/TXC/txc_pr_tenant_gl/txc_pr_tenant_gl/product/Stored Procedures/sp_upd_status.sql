CREATE PROCEDURE [product].[sp_upd_status]
         @product_id int
		 ,@Status int
         ,@UserName nvarchar(250) 
		 ,@Result int output
AS
BEGIN
	SET XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;       


		if exists(select 1 from [product].[tb_p_product] with(nolock) where product_id = @product_id AND [Status] != @Status)
		begin
			update product.tb_p_product
			set [status] = @Status
			,last_updated_on = getutcdate()
			,last_updated_by = @UserName
			where product_id = @product_id

			set @Result = 1;
		end
		else
		begin
			set @Result = 0;
		end
		
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