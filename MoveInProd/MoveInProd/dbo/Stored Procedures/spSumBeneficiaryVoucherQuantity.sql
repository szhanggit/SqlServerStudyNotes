-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/12/18
-- Description:	Assign voucher.
-- =============================================
CREATE PROCEDURE [dbo].[spSumBeneficiaryVoucherQuantity]
	@OrderLineId				INT,
	@VoucherQuantity			INT		OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT @VoucherQuantity = SUM([VoucherQuantity])
	FROM [dbo].[OrderBeneficiaryInfo]
	WHERE [OrderLineId] = @OrderLineId
END

