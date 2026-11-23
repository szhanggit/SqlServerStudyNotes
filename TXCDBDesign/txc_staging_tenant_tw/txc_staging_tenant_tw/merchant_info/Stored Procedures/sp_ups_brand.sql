CREATE PROCEDURE [merchant_info].[sp_ups_brand]
(    
	@brand_id int,
	@brand_name nvarchar(100),
	@media_id int,
	@status int,
	@created_by NVARCHAR(50)
)
AS
BEGIN

		Update merchant_info.tb_b_brand 
		SET 
			brand_name=@brand_name,
			media_id=@media_id,
			status=@status,			
			created_by=@created_by
		WHERE id = @brand_id
		
END