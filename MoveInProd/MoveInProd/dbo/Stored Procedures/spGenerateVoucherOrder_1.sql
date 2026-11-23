-- =============================================
-- Author:		Knight YAO
-- Create date: 2016/06/15
-- Description:	Generate voucher order lines.
-- =============================================
CREATE PROCEDURE spGenerateVoucherOrder
	@OrderId	int
   ,@IsSuccess  bit output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	  if(exists(select 1 from VoucherOrder with(nolock) where OrderId = @OrderId))
	  BEGIN
	    set @IsSuccess = 1
	    return
	  END
	  
	BEGIN TRAN

	BEGIN TRY
	
		Insert Into VoucherOrder (OrderId, 
		                         OrderLineId,
								 OrderBeneficiaryInfoId,
								 OrderSN,
								 OrderLineSN,
								 OrderBeneficiaryInfoSN,
								 IsEmailDelivery,
								 IsSLMSDelivery,
								 CreationTime)
		select o.id as OrderId, 
		       ol.id as OrderLineId,
			   obi.id as OrderBeneficiaryInfoId,
               ROW_NUMBER()OVER(Order By ol.id)As OrderSN,
	           ROW_NUMBER()OVER(Partition By ol.id Order By ol.id)As OrderLineSN,
	           t.id as OrderBeneficiaryInfoSN,
			   case when o.IsDirectDelivery = 1 and rtrim(ltrim(isnull(obi.Email,'')))<>'' then 1 else 0 end,
			   case when o.IsDirectDelivery = 1 and rtrim(ltrim(isnull(obi.Mobile,'')))<>'' then 1 else 0 end,
			   GETDATE()
		from [order] o with(nolock) 
			join orderline ol with(nolock) on o.id = ol.orderid
			join orderbeneficiaryinfo obi with(nolock) on ol.id = obi.orderlineid
			join Tally t with(nolock) on obi.voucherquantity>=t.Id
		where o.id = @OrderId

		set @IsSuccess = 1
	END TRY
	BEGIN CATCH
		set @IsSuccess = 0
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION
		return
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END
