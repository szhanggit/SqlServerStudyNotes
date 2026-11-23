CREATE PROCEDURE [merchant_info].[sp_chk_acceptance_loop]
		 @acceptance_loop_id int
		 ,@Result int output
		 ,@Status int output
AS
BEGIN
	SET XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;       


		if exists(select 1 from [merchant_info].[tb_al_acceptance_loop] with(nolock) where acceptance_loop_id = @acceptance_loop_id AND [Status] = 1)
		begin
			set @Result = 1;
			set @Status = 1;
		end
                else if exists(select 1 from [merchant_info].[tb_al_acceptance_loop] with(nolock) where acceptance_loop_id = @acceptance_loop_id AND [Status] = 0)
		begin
			set @Result = 1;
			set @Status = 0;
		end
		else
		begin
			set @Result = -1;
                        set @Status = -1;
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