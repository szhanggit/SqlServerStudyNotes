-- =============================================
-- Author:		Steven Yu
-- Create date:     2015/03/06
-- Description:	Publish order.
-- =============================================
CREATE PROCEDURE [dbo].[spPublishOrder]
     @OrderId                      int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE OBI
     SET ProductVersionId = PVA.Id
     FROM [dbo].[OrderBeneficiaryInfo] OBI
     INNER JOIN OrderLine OL ON OBI.OrderLineId = OL.Id
     INNER JOIN [Order] O ON OL.OrderId = O.Id AND O.Id = @OrderId
     INNER JOIN ClientQuotationProduct CQP ON OL.ClientQuotationProductId = CQP.Id
     INNER JOIN ProductVersion PV ON CQP.ProductVersionId = PV.Id
     INNER JOIN Product P ON PV.ProductId = P.Id
     INNER JOIN ProductVersion PVA ON P.Id = PVA.ProductId AND PVA.IsCurrentVersion = 1
END

