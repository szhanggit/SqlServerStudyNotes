CREATE PROCEDURE [dbo].[spReleaseRCN]
@RCN varchar(50)
AS
BEGIN
    SET NOCOUNT ON
	BEGIN TRAN

	BEGIN TRY
--declare @RCN varchar(50)= '''ARP-HDF1D-U624f-c88c31-590673-6577670'
declare @ClientOrderLineId int
declare @VoucherStockTable varchar(50)
declare @sql nvarchar(max)
select @ClientOrderLineId = Id from EMV_ClientOrderLine with(nolock) where RCN=@RCN

Select top 1 @VoucherStockTable= p.VoucherStockTableName from EMV_VoucherClientOrder e with(nolock)
join ProgramVoucherRoute p with(nolock) on p.ProgramId = e.ProgramId
where e.ClientOrderLineId = @ClientOrderLineId

set @sql=N'update v  set v.StockStatus = 0
from '+@VoucherStockTable+N' v
join EMV_VoucherClientOrder evco with(nolock) on evco.VoucherNumber = v.VoucherNumber and v.ProgramId = evco.ProgramId
where evco.ClientOrderLineId =' +CONVERT(nvarchar, @ClientOrderLineId)

delete v 
from Voucher v
join EMV_VoucherClientOrder evco with(nolock) on evco.VoucherNumber = v.VoucherNumber and v.ProgramId = evco.ProgramId
where evco.ClientOrderLineId = @ClientOrderLineId

--select @sql
exec(@sql)

--update v  set v.StockStatus = 0
--from VoucherStock_C_67 v
--join EMV_VoucherClientOrder evco with(nolock) on evco.VoucherNumber = v.VoucherNumber and v.ProgramId = evco.ProgramId
--where evco.ClientOrderLineId = @ClientOrderLineId

delete EMV_VoucherClientOrder where ClientOrderLineId = @ClientOrderLineId
delete EXT_IN_APIOrderInfo where RCN=@RCN
update EMV_ClientOrderLine set Status=2 , OrderNumber = null where RCN=@RCN
COMMIT;
	END TRY
	BEGIN CATCH
		ROLLBACK;
	END CATCH;
END
