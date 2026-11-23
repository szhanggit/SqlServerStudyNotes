-- =============================================
-- Author:		Eagles Wang
-- Create date: 2017/04/25
-- Description:	This method retrieves the AVAILABLE quantity for a specific product code for a specific API order
-- =============================================
CREATE PROCEDURE [dbo].[spGetInventoryInfoList]
	 @OrderNumber	nvarchar(4000)
AS

BEGIN
	SELECT  
	     p.ProductCode,
	     p.ProductName,
	     COUNT(*) AS AvailableQuantity
	FROM [Order] o WITH ( NOLOCK )
		INNER JOIN OrderLine ol WITH ( NOLOCK ) ON o.Id = ol.OrderId 
		INNER JOIN ClientQuotationProduct cqp WITH ( NOLOCK ) ON ol.ClientQuotationProductId = cqp.Id
		INNER JOIN ProductVersion pv WITH ( NOLOCK ) ON cqp.ProductVersionId = pv.Id
		INNER JOIN Product p WITH ( NOLOCK ) ON pv.ProductId = p.Id
		INNER JOIN Voucher v WITH ( NOLOCK ) ON p.Id = v.ProductId
	WHERE o.Status = 64
	    AND cqp.Status = 32
		AND p.Status = 1
		AND (v.Status = 64 OR v.Status = 128 OR v.Status = 256)
		AND v.BeneficiaryInfoId is Null
		AND o.OrderNumber = @OrderNumber
	GROUP BY p.ProductCode,p.ProductName

END
