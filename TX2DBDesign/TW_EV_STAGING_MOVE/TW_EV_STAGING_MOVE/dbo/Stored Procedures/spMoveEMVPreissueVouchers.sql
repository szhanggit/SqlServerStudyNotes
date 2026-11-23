
CREATE PROCEDURE [dbo].[spMoveEMVPreissueVouchers] 
	@Count INT,
    @ClientOrderLineId INT,
    @TableName varchar(50),
    @Prefix BIGINT,
    @SessionId varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @sql nvarchar(3000);
    SET @sql = 'declare @newId varchar(50) = CONVERT(varchar(50),NEWID())
     update top(@Count) '+@TableName+' set SessionId = @newId, AssignTime = getdate()
                                        where StockStatus = 2 and SessionId = @SessionId

                                    insert into EMV_VoucherClientOrder(ClientOrderLineId,ProgramId,VoucherNumber,ProductId,BalanceAvailable,[STATUS],ExpiryDate,[GUID],ReservationBatchId,ShortUrl,AuthCode,ExtendId,PinCode) 
	                                    select @ClientOrderLineId, stock.ProgramId,stock.VoucherNumber,stock.ProductId,stock.BalanceAvailable,64,stock.ExpiryDate,stock.[GUID],stock.ReservationBatchId,
                                        stock.ShortUrl,stock.AuthCode,@Prefix + stock.Id,stock.PinCode from '+@TableName+' stock with(nolock)
	                                    where StockStatus = 2 and SessionId = @newId

                                    update '+@TableName+' set StockStatus = 1 where StockStatus = 2 and SessionId = @newId
                                    update EMV_ClientOrderLine set [Status] = 3 where Id = @ClientOrderLineId'

    exec sp_executesql  @sql, N'@Count INT,@ClientOrderLineId INT,@Prefix BIGINT,@SessionId varchar(50)', @Count,@ClientOrderLineId,@Prefix,@SessionId;
END
