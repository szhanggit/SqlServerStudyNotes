CREATE PROCEDURE [order].[sp_chk_emv_rcn]
	@IsSuccess bit output,
	@rcn nvarchar(100)
AS
BEGIN
	SET XACT_ABORT ON;
		
		SET @IsSuccess = 0;

		if not exists(SELECT 1 FROM tb_eco_emv_rcn_key v WITH(NOLOCK) where rcn = @rcn)
		BEGIN
			SET @IsSuccess = 1;
		END
END