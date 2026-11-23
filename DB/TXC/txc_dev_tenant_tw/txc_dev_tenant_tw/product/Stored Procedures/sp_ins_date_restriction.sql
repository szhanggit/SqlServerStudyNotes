CREATE PROCEDURE [product].[sp_ins_date_restriction]
         @product_id int
         ,@UserName nvarchar(250) 
		 ,@DateRestrictionList [general].[DateTimeListType] Readonly
		 ,@Result int output
AS
BEGIN
	SET XACT_ABORT ON;
	set @Result = 0;
	
    BEGIN TRY

        BEGIN TRANSACTION;       
		
		Declare @redeem_date_blacklist_id int
		INSERT [product].[tb_p_product_redeem_date_blacklist] DEFAULT VALUES;						
		SELECT @redeem_date_blacklist_id = SCOPE_IDENTITY();		

		insert into [product].[tb_p_product_redeem_date_blacklist_set] (product_redeem_date_blacklist_id, black_date)						
		select @redeem_date_blacklist_id as product_redeem_date_blacklist_id, drl.[Date] from @DateRestrictionList drl
	
		set @Result = @redeem_date_blacklist_id;
		
        COMMIT TRANSACTION;
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