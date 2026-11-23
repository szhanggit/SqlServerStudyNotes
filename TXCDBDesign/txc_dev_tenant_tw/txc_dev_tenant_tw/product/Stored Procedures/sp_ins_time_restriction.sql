CREATE PROCEDURE [product].[sp_ins_time_restriction]
         @product_id int
         ,@UserName nvarchar(250) 
		 ,@TimeRestrictionList [product].[TimeRestrictionListType] Readonly
		 ,@Result int output
AS
BEGIN
	SET XACT_ABORT ON;
	set @Result = 0;
    BEGIN TRY

        BEGIN TRANSACTION;       
		Declare @product_redeem_time_restriction_id int
		
		INSERT [product].[tb_p_product_redeem_time_restriction] DEFAULT VALUES;						
		SELECT @product_redeem_time_restriction_id = SCOPE_IDENTITY();		

		insert into [product].[tb_p_product_redeem_time_restriction_set] (product_redeem_time_restriction_id, day_of_week, start_time, end_time)						
		select @product_redeem_time_restriction_id as product_redeem_time_restriction_id, trl.day_of_week, trl.start_time, trl.end_time from @TimeRestrictionList trl

		set @Result = @product_redeem_time_restriction_id;
		
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