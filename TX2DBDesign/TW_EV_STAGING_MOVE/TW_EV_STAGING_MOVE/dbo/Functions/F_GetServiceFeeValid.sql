
CREATE FUNCTION [dbo].[F_GetServiceFeeValid]
    (
      @ServiceFeeId INT ,
      @CalculationRule VARCHAR(50) ,
	  @CalculationExpression TINYINT ,
	  @Email VARCHAR(100) ,
	  @Mobile VARCHAR(50) ,
	  @Instance	varchar(20)     = NULL
	)
RETURNS bit
AS
    BEGIN
        DECLARE @ret AS bit
        SELECT  @ret = 1
			
		IF ( @CalculationRule = 'ByDeliveryMethod' AND @CalculationExpression = 1  AND len(isnull(@Mobile,'')) = 0 AND len(isnull(@Email,'')) > 0 )
            SET @ret = 0
			
		IF ( @CalculationRule = 'ByDeliveryMethod' AND @CalculationExpression = 2  AND len(isnull(@Email,'')) = 0 AND len(isnull(@Mobile,'')) > 0 )
            SET @ret = 0
			
        RETURN @ret
    END
