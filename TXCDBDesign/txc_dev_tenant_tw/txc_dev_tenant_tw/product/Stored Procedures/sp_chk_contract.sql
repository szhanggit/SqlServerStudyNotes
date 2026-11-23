CREATE PROCEDURE [product].[sp_chk_contract]
		 @product_id int
		 ,@Result int output
AS
BEGIN
	SET XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;       


		set @Result = 1

		
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