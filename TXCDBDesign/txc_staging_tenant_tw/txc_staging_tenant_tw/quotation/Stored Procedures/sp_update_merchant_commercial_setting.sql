CREATE PROCEDURE [quotation].[sp_update_merchant_commercial_setting]
	@IsSuccess bit output
	,@id int
	,@merchant_id int 
	,@product_id int
	,@valid_from datetime
	,@valid_to datetime
	,@is_use_default_cost bit
AS
BEGIN
	DECLARE @current_valid_from DATETIME
	DECLARE @current_valid_to DATETIME
	DECLARE @pid int
	DECLARE @nid int
	set @IsSuccess=0
	select @current_valid_from = valid_from ,
	@current_valid_to = valid_to 
	from tb_mcs_merchant_commercial_setting with(nolock) 
	where merchant_id = @merchant_id and product_id = @product_id and id = @id

	IF (@current_valid_from<>@valid_from and @current_valid_from<GETDATE())
	BEGIN
		RETURN
	END
	ELSE
	BEGIN
		select top 1 @pid = id
		from tb_mcs_merchant_commercial_setting with(nolock) 
		where merchant_id = @merchant_id and product_id = @product_id and id < @id
		order by id desc
	END

	IF (@current_valid_to<>@valid_to and @valid_to<GETDATE())
	BEGIN
		RETURN
	END
	ELSE
	BEGIN
		select top 1 @nid = id
		from tb_mcs_merchant_commercial_setting with(nolock) 
		where merchant_id = @merchant_id and product_id = @product_id and id > @id
		order by id
	END

	SET XACT_ABORT ON;

	BEGIN TRY

	    BEGIN TRANSACTION;

	update tb_mcs_merchant_commercial_setting 
	set valid_from = @valid_from
		,valid_to = @valid_to
		,is_use_default_cost = @is_use_default_cost
	where id= @id and merchant_id = @merchant_id and product_id = @product_id

	IF (@pid is not null and @pid >0)
	BEGIN
		update tb_mcs_merchant_commercial_setting 
		set valid_to = DATEADD(SECOND,-1,@valid_from)
		where id= @pid
	END

	IF (@nid is not null and @nid >0)
	BEGIN
		update tb_mcs_merchant_commercial_setting 
		set valid_from = DATEADD(SECOND,1,@valid_to)
		where id= @nid
	END

	set @IsSuccess = 1
		stop_process:

		IF @IsSuccess = 0
			BEGIN
				ROLLBACK TRANSACTION;
			END
        ELSE
			BEGIN
				COMMIT TRANSACTION;
			END
	END TRY
	BEGIN CATCH
       IF @@TRANCOUNT > 0
       BEGIN
          ROLLBACK TRANSACTION
       END;

	   THROW;
	END CATCH

	SET NOCOUNT, XACT_ABORT OFF;
END