
CREATE PROCEDURE spSavePreIssuedCampaignOrderInfo
    @OrderId bigint 
AS
    BEGIN
		DECLARE @OrderNumber varchar(50)
		set @OrderNumber = (select OrderNumber from dbo.[Order] o with(NOLOCK) where o.Id = @OrderId);
	
		INSERT INTO dbo.PreIssuedCampaignOrderInfo(OrderNumber,ProductCode,ReservationCode) 
		SELECT DISTINCT o.OrderNumber,p.ProductCode,vrc.ReservationCode from dbo.[Order] o with(NOLOCK) 
		INNER JOIN dbo.OrderLine ol with(NOLOCK) ON o.Id = ol.OrderId
		INNER JOIN dbo.VoucherReservationCode vrc with(NOLOCK) ON ol.VoucherReservationCodeId = vrc.Id
		INNER JOIN dbo.ClientQuotationProduct cqp with(NOLOCK) ON ol.ClientQuotationProductId = cqp.Id
		INNER JOIN dbo.ProductVersion pv with(NOLOCK) ON cqp.ProductVersionId = pv.Id
		INNER JOIN dbo.Product p with(NOLOCK) ON pv.ProductId = p.Id
		WHERE o.Id = @OrderId
        	EXCEPT
		SELECT OrderNumber,ProductCode,ReservationCode FROM dbo.PreIssuedCampaignOrderInfo picoi with(NOLOCK) WHERE picoi.OrderNumber = @OrderNumber

		IF (@@ROWCOUNT > 0)
			SELECT * FROM dbo.PreIssuedCampaignOrderInfo picoi with(NOLOCK) WHERE picoi.OrderNumber = @OrderNumber;
		
    END
