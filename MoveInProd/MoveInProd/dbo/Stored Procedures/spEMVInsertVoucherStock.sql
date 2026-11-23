
CREATE PROCEDURE [dbo].[spEMVInsertVoucherStock]
    @TableName varchar(50),
	@Prefix BIGINT,
	@Vouchers EMV_VoucherStockUpload Readonly
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @sql nvarchar(3000);
    SET @sql = 'declare @newId varchar(50) = CONVERT(varchar(50),NEWID())
	declare @now datetime = getdate()
	insert into '+@TableName+' ([ProgramId]
           ,[ProductId]
           ,[VoucherNumber]
           ,[ShortUrl]
           ,[AuthCode]
           ,[SessionId]
           ,[StockStatus]
           ,[CreateTime]
           ,[AssignTime]
           ,[GUID]
           ,[BalanceAvailable]
           ,[ReservationBatchId]
           ,[ExpiryDate]
           ,[PinCode])
	Select ProgramId,ProductId,VoucherNumber,ShortUrl,AuthCode,@newId,0,@now,NULL,GUID,BalanceAvailable,ReservationBatchId,ExpiryDate,PinCode from @Vouchers;

	INSERT INTO EXT_INGCID(Id, VoucherNumber, ProgramId, GCID) 
	SELECT @Prefix + V.Id, V.VoucherNumber, V.ProgramId, evs.GCID
	from '+@TableName+' V with(nolock)
	join @Vouchers vv on vv.VoucherNumber=V.VoucherNumber
	join dbo.EMV_VoucherStock evs with(nolock) on evs.VoucherCode = V.VoucherNumber and evs.GUID = V.GUID
	where V.[SessionId] = @newId;

	Select * from '+@TableName+' with(nolock) where [StockStatus] = 0 AND [SessionId] = @newId;'
	exec sp_executesql  @sql, N'@Vouchers EMV_VoucherStockUpload Readonly,@Prefix BIGINT ', @Vouchers,@Prefix;
END
