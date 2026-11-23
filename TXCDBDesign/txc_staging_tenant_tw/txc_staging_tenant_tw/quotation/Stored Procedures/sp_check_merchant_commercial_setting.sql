CREATE PROCEDURE [quotation].[sp_check_merchant_commercial_setting]
	@IsSuccess bit output
	,@merchant_id int 
	,@product_id int
	,@valid_from datetime 
	,@valid_to datetime
AS
BEGIN
	DECLARE @count int = 0;
	select @count = count(1) from tb_mcs_merchant_commercial_setting with(nolock)
	where merchant_id = @merchant_id and product_id = @product_id 
		and ((@valid_from>=valid_from and @valid_from<=@valid_to) or (valid_from>=@valid_from and valid_from<=@valid_to))

	IF(@count=0)
	BEGIN
		set @IsSuccess = 1
	END
	ELSE IF(@count=1)
	BEGIN
		IF EXISTS(select 1 from tb_mcs_merchant_commercial_setting with(nolock) 
			where merchant_id = @merchant_id and product_id = @product_id 
			and (@valid_from>=valid_from and @valid_from<=@valid_to))
		BEGIN
			set @IsSuccess = 1
		END
	END
END