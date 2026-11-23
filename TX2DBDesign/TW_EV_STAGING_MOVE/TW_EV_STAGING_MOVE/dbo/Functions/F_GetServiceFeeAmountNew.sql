
CREATE FUNCTION [dbo].[F_GetServiceFeeAmountNew]
    (
      @ServiceFeeId INT ,
      @CalculationRule VARCHAR(50) ,
	  @CalculationExpression TINYINT ,
      @TranType SMALLINT , --401 issue,101 redemption
      @ServiceFeeSoldPrice NUMERIC(15, 4) ,
      @TranQuantity INT,
	  @MGCType CHAR = 'G' ,--M:Master Voucher; G:General Vocher; C:Child Voucher
	  @Mobile VARCHAR(50) ,
	  @Instance	varchar(20)     = NULL
	)
RETURNS NUMERIC(20, 6)
AS
    BEGIN
--101	Redeem
--201	Reverse Redeem
--103	Pre-Auth Complete
--203	Reverse Pre-Auth Complete
--401	Issue
--501	Reverse Issue
--404	Trash
--405   TrashNoMoney
--503	ReverseExpire
        DECLARE @ret AS NUMERIC(20, 6)
        SELECT  @ret = 0
		DECLARE @tax DECIMAL(10,5) = 1;
	 IF @Instance IS NOT NULL AND @Instance = 'TW'
	 BEGIN
	     SET @MGCType = 'G';
		 SET @tax = 1.05;
	 END
        IF ( @CalculationRule = 'ByTranQuantity' )
            SET @ret = @ServiceFeeSoldPrice * @TranQuantity
			
		IF ( @CalculationRule = 'ByDeliveryMethod' AND @CalculationExpression = 1  AND len(isnull(@Mobile,'')) > 0 )
            SET @ret = @ServiceFeeSoldPrice * @TranQuantity
			
		IF(@MGCType = 'M' AND (@TranType = 101 OR @TranType = 201 OR @TranType = 103 OR @TranType = 203))
			SET @ret = 0;
		IF(@MGCType = 'C' AND (@TranType = 401 OR @TranType = 501 OR @TranType = 404 OR @TranType = 405))
			SET @ret = 0;
        RETURN ISNULL(@ret,0)
    END

