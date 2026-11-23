-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spGetServiceFeeByQuotationAndProduct
	-- Add the parameters for the stored procedure here
	@ProductCode VARCHAR(50),
	@QuotationNumber VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @CurrentDateTime DATETIME;
	SET @CurrentDateTime = GETDATE()

    -- Insert statements for procedure here
	SELECT  sfd.Name AS ServiceFeeName
		,ISNULL(cqpsftt.SoldPriceWithTax,0) AS FeeWithTax     
	FROM dbo.ClientQuotation AS cq WITH ( NOLOCK )
        INNER JOIN dbo.ClientQuotationProduct AS cqp WITH ( NOLOCK ) ON cqp.ClientQuotationId = cq.Id
        LEFT JOIN dbo.ClientQuotationProductServiceFeeTriggerTime AS cqpsftt WITH ( NOLOCK ) ON cqpsftt.ClientQuotationProductId = cqp.Id
        LEFT JOIN dbo.ServiceFeeTriggerTime AS sftt WITH ( NOLOCK ) ON sftt.Id = cqpsftt.ServiceFeeTriggerTimeId
                                                        AND sftt.TranType = 401
        LEFT JOIN dbo.ServiceFee AS sf WITH ( NOLOCK ) ON sf.Id = sftt.ServiceFeeId
        LEFT JOIN dbo.Dictionary AS sfd WITH ( NOLOCK ) ON sfd.Id = sf.ServiceFeeNameId
		INNER JOIN dbo.ProductVersion AS pv WITH ( NOLOCK ) ON pv.Id = cqp.ProductVersionId
		INNER JOIN dbo.Product AS p ON p.Id = pv.ProductId
	WHERE cq.QuotationNumber = @QuotationNumber
		AND P.ProductCode = @ProductCode
		AND cqpsftt.ValidityFrom <= @CurrentDateTime
		AND cqpsftt.ValidityEnd >= @CurrentDateTime
		AND cqpsftt.Status = 2
END
