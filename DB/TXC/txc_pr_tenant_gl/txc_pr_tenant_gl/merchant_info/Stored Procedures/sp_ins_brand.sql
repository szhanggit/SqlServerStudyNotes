Create PROCEDURE [merchant_info].[sp_ins_brand]
(    
	@brand_name nvarchar(100),
	@media_id int,
	@status int,
	@created_by NVARCHAR(50),
	@output INT OUTPUT
)
AS
BEGIN

		INSERT INTO merchant_info.tb_b_brand 
		(
			brand_name,
			media_id,
			status,			
			created_by,
			created_on
		) 
		VALUES
		(
			@brand_name,
			@media_id,
			@status,			
			@created_by,
			GETUTCDATE()
		)    
		SET @output = SCOPE_IDENTITY()
END