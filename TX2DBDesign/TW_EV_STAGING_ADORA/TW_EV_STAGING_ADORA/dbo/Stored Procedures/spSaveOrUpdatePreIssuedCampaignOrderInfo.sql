create proc spSaveOrUpdatePreIssuedCampaignOrderInfo
@UpdatedOrInsertedTable PreIssuedCampaignOrderInfoType READONLY,
@OrderNumber varchar(50)
as
begin
	
	INSERT INTO dbo.PreIssuedCampaignOrderInfo(OrderNumber,ProductCode,ReservationCode) 
	SELECT OrderNumber,ProductCode,ReservationCode FROM @UpdatedOrInsertedTable UIT
	EXCEPT
	SELECT OrderNumber,ProductCode,ReservationCode FROM dbo.PreIssuedCampaignOrderInfo picoi with(NOLOCK) WHERE picoi.OrderNumber = @OrderNumber
			
end
