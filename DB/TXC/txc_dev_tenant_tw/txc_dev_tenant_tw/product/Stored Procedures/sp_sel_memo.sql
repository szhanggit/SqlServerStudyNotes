CREATE PROCEDURE [product].[sp_sel_memo]
         @product_id int
AS
BEGIN
	SET XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;       

		select 
		operation_note as OperationNote
		, sales_note as SalesNote
		, customer_service_note as CustomerServiceNote
		from [product].[tb_p_product] with(nolock)
		where product_id = @product_id
						
		
        COMMIT TRANSACTION;
	
		SELECT @@ROWCOUNT;
    END TRY
    BEGIN CATCH 
       IF @@TRANCOUNT  > 0
       BEGIN
          ROLLBACK TRANSACTION		  
       END;

	   THROW;
    END CATCH;

    SET NOCOUNT, XACT_ABORT OFF;
END