
CREATE PROCEDURE spIsCampaignOrder
	@ExternalOrderId VARCHAR(50), 
	@IsSuccess BIT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	IF EXISTS(
			SELECT 1 FROM [dbo].[PreIssuedCampaignOrderInfo] WITH(NOLOCK)
			WHERE OrderNumber = @ExternalOrderId
		)
	     SET @IsSuccess = 1
	  ELSE
	     SET @IsSuccess = 0
END
