-- =============================================
-- Author:		Zhu Jianhua
-- Create date: 2017-01-23
-- Description:	Update Total Quantity
-- =============================================
CREATE PROCEDURE spUpdateTotalQuantity
	-- Add the parameters for the stored procedure here 
	@QuotationNumber varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    BEGIN TRAN

	UPDATE ol
	SET ol.totalquantity = TEMP.VoucherQuantity
	FROM OrderLine ol WITH(NOLOCK) 
	JOIN(
		SELECT ol.Id, SUM(obi.VoucherQuantity) AS VoucherQuantity
		FROM OrderLine ol WITH(NOLOCK) 
			JOIN OrderBeneficiaryInfo obi WITH(NOLOCK) ON ol.id = obi.OrderLineId
			JOIN ClientQuotationProduct cqp WITH(NOLOCK) ON ol.ClientQuotationProductId = cqp.id
			JOIN ClientQuotation cq WITH(NOLOCK) ON cqp.ClientQuotationId = cq.id
		WHERE cq.QuotationNumber = @QuotationNumber
		GROUP BY cqp.Id,OL.Id) TEMP ON ol.Id = TEMP.Id

	IF @@ERROR <> 0
		ROLLBACK TRAN
	ELSE
		COMMIT TRAN


END
