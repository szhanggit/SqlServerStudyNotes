CREATE PROCEDURE [product].[sp_upd_time_stopissue]
         @product_id int
         ,@UserName nvarchar(250) 
		 ,@CanIssue bit
		 ,@StopIssueTime DateTime = null
		 ,@Result int output
AS
BEGIN
	SET XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;       
		declare @version int = 0

		if not exists (select * from [product].[tb_p_product] with(nolock) where product_id = @product_id)
		begin
			set @Result = 2;
		end
		else
		begin
		
		Update [product].[tb_p_product]
		set can_issue = @CanIssue
		, stop_issue_time = @StopIssueTime
		, last_updated_by = @UserName
		, last_updated_on = GETUTCDATE()
		where product_id = @product_id			
		
		set @Result = 1;
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