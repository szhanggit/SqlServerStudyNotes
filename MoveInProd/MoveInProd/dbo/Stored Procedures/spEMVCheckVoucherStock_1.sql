
CREATE PROCEDURE [dbo].[spEMVCheckVoucherStock]
    @TableName varchar(50),
	@Vouchers EMV_VoucherStockUpload Readonly
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @sql nvarchar(3000);
    SET @sql = 'Select VS.* from '+@TableName+' As Vs With(NOLOCK) Join @Vouchers As V On V.VoucherNumber= VS.VoucherNumber And V.ProgramId = VS.ProgramId'
	exec sp_executesql  @sql, N'@Vouchers EMV_VoucherStockUpload Readonly', @Vouchers;
END
