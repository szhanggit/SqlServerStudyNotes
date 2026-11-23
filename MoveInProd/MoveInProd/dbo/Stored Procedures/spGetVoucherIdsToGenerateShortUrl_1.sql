-- =============================================
-- Author:		Bruce CHEN
-- Create date: 2016/8/15
-- Description:	spGetVoucher
-- =============================================
CREATE PROCEDURE [dbo].[spGetVoucherIdsToGenerateShortUrl]
 @OrderID int
AS 
BEGIN
	SELECT vo.VoucherId as Id 
	from VoucherOrder vo 
	     join [Order] o on vo.OrderId=o.id
	     join [OrderLine] ol on ol.Id=vo.OrderLineId
	     left join VoucherShortUrl vs on vo.VoucherId = vs.id
	WHERE o.id=@OrderID
	     and ol.NeedShortUrl=1
	     and vs.id is null
END


