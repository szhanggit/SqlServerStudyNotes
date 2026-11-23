CREATE PROCEDURE [quotation].[sp_ins_merchant_commercial_setting]
	@MerchantCommercialSettingId int output,
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,
	
	@merchant_id int 
	,@product_version_id int 
	,@product_id int
	,@valid_from datetime 
	,@valid_to datetime
	,@is_use_default_cost bit 
	,@created_by nvarchar(50)
	,@created_on datetime
AS
BEGIN
    
	SET XACT_ABORT ON;

	BEGIN TRY

	    BEGIN TRANSACTION;
		
		SET @IsSuccess = 0;
		SET @ErrorMessage = null;
		SET @MerchantCommercialSettingId = 0;

		DECLARE @created_id table (id int)
		DECLARE @pid int
		DECLARE @p_valid_to DATETIME

		select top 1 @pid = id,@p_valid_to = valid_to
		from tb_mcs_merchant_commercial_setting with(nolock) 
		where merchant_id = @merchant_id and product_id = @product_id
		order by id desc

	    INSERT INTO tb_mcs_merchant_commercial_setting
		(
			merchant_id  
			,product_version_id
			,product_id
			,valid_from
			,valid_to
			,is_use_default_cost
			,created_by
			,created_on
		)
		OUTPUT INSERTED.id INTO @created_id
		VALUES
		(
			@merchant_id  
			,@product_version_id
			,@product_id
			,@valid_from
			,@valid_to
			,@is_use_default_cost
			,@created_by
			,@created_on
		);
		IF (@valid_from < @p_valid_to)
		BEGIN
			update tb_mcs_merchant_commercial_setting 
			set valid_to = DATEADD(SECOND,-1,@valid_from)
			where id= @pid
		END

		IF @@ROWCOUNT > 0
			BEGIN
				SET @IsSuccess = 1;
				SELECT @MerchantCommercialSettingId = id FROM @created_id
			END
		ELSE
			BEGIN
				SET @ErrorMessage = 'failed to add merchant commercial setting';
			END

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