CREATE PROCEDURE [product].[sp_chk_product]
		 @product_id int
		 ,@Result int output
		 ,@MultiSelectionType int output
AS
BEGIN
	SET XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;       


		if exists(select 1 from [product].[tb_p_product] with(nolock) where product_id = @product_id)
		begin
			set @Result = 1;
			select @MultiSelectionType = multiple_selection_type from [product].[tb_p_product] with(nolock) where product_id = @product_id
		end
		else
		begin
			set @Result = -1;
			set @MultiSelectionType = -1;
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