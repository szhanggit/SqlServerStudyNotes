
CREATE PROCEDURE spGenerateVoucherOrderBuffer
	@OrderId	int
   ,@IsSuccess  bit output
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM dbo.VoucherOrderBuffer WITH(NOLOCK) WHERE OrderId = @OrderId)
	BEGIN
		SET @IsSuccess=1;
		RETURN;
	END;
	  
	BEGIN TRAN
	BEGIN TRY
		Insert Into dbo.VoucherOrderBuffer 
						(OrderId, 
		                OrderLineId,
						OrderBeneficiaryInfoId,
						VoucherQuantity,
						OrderSN,
						OrderLineSN,
						OrderBeneficiaryInfoSN,
						IsEmailDelivery,
						IsSLMSDelivery,
						CreationTime)
			select o.Id, 
				   ol.Id,
				   obi.Id,
				   obi.VoucherQuantity,
				   ROW_NUMBER()OVER(Order By ol.Id) AS OrderSN,
				   ROW_NUMBER()OVER(Partition By ol.Id Order By ol.Id) AS OrderLineSN,
				   t.Id as OrderBeneficiaryInfoSN,
				   case when o.IsDirectDelivery = 1 and rtrim(ltrim(isnull(obi.Email,'')))<>'' then 1 else 0 end,
				   case when o.IsDirectDelivery = 1 and rtrim(ltrim(isnull(obi.Mobile,'')))<>'' then 1 else 0 end,
				   GETDATE()
				FROM dbo.[Order] o WITH(NOLOCK) 
				JOIN dbo.OrderLine ol WITH(NOLOCK) ON ol.OrderId = o.Id
				JOIN dbo.OrderBeneficiaryInfo obi WITH(NOLOCK) ON obi.OrderLineId = ol.Id
				JOIN dbo.Tally t WITH(NOLOCK) ON obi.VoucherQuantity>=t.Id
			where o.Id = @OrderId

		COMMIT;
		set @IsSuccess = 1
	END TRY
	BEGIN CATCH
		ROLLBACK;
		set @IsSuccess = 0
	END CATCH;
END
