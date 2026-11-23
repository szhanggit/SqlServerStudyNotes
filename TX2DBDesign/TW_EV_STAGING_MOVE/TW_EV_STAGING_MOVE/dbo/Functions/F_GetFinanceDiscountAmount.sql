
CREATE FUNCTION [dbo].[F_GetFinanceDiscountAmount]
    (
      @FinanceFormulaType TINYINT , --1 prepaid, 2 postpaid, 3 Cost
      @FaceValue INT , --cent
      @TranType SMALLINT ,--
      @TranAmount INT ,
      @ProductType TINYINT , -- 1--product based, 2--Value based
      @SoldPrice NUMERIC(15, 4),
	  @MultipleSelectionType INT,
	  @MGCType CHAR = 'G' --M:Master Voucher; G:General Vocher; C:Child Voucher
    ,@Instance			varchar(20)     = NULL
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
--403   Expire
--405   TrashNoMoney
--MultipleSelectionType General = 0, Master = 1, Child = 2
DECLARE @ret AS NUMERIC(20, 6)
DECLARE @tax DECIMAL(10,5) = 1;
	 IF @Instance IS NOT NULL AND @Instance = 'TW'
	 BEGIN
	     SET @MGCType = 'G';
		 SET @tax = 1.05;
	 END
SELECT  @ret = 0

IF ( @FinanceFormulaType = 1 AND (@MultipleSelectionType=0 OR @MultipleSelectionType=2))
	BEGIN
		IF ( @ProductType = 1 )
			BEGIN
				IF (@TranType = 101 OR  @TranType = 103 OR @TranType = 403)
					SET @ret = (@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount
				IF ( @TranType = 201 OR  @TranType = 203 OR @TranType = 503)
					SET @ret = (@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount * -1
			END
		ELSE
			BEGIN
				IF ( @TranType = 101 OR  @TranType = 103 OR @TranType = 403)
					SET @ret = case when @FaceValue = 0 then 0 else round((@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount/round(@FaceValue*@tax, 2), 4) end
				IF ( @TranType = 201 OR  @TranType = 203 OR @TranType = 503)
					SET @ret =  case when @FaceValue = 0 then 0 else round((@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount/round(@FaceValue*@tax, 2), 4) * -1 end
			END
	END
 IF ( @FinanceFormulaType = 1 AND @MultipleSelectionType=1)
	BEGIN
		IF ( @ProductType = 1 )
			BEGIN
				IF (@TranType = 403)
					SET @ret = (@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount
				IF (@TranType = 503)
					SET @ret = (@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount * -1
			END
		ELSE
			BEGIN
				IF (@TranType = 403)
					SET @ret = case when @FaceValue = 0 then 0 else round((@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount/round(@FaceValue*@tax, 2), 4) end
				IF (@TranType = 503)
					SET @ret = case when @FaceValue = 0 then 0 else round((@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount/round(@FaceValue*@tax, 2), 4) * -1 end
			END
	END

IF ( @FinanceFormulaType = 2 AND (@MultipleSelectionType=0 OR @MultipleSelectionType=2))
	BEGIN

	   IF ( @ProductType = 1 )
			BEGIN
				IF (@TranType = 101 OR  @TranType = 103)
					SET @ret = (@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount
				IF ( @TranType = 201 OR  @TranType = 203 OR @TranType = 503)
					SET @ret = (@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount * -1
			END
		ELSE
			BEGIN
				IF ( @TranType = 101 OR  @TranType = 103)
					SET @ret = case when @FaceValue = 0 then 0 else round((@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount/round(@FaceValue*@tax, 2), 4) end
				IF ( @TranType = 201 OR  @TranType = 203)
					SET @ret = case when @FaceValue = 0 then 0 else round((@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount/round(@FaceValue*@tax, 2), 4) * -1 end
			END
	END
IF(@MGCType = 'M' AND (@TranType = 101 OR @TranType = 201 OR @TranType = 103 OR @TranType = 203))
	SET @ret = 0;
IF(@MGCType = 'C' AND (@TranType = 401 OR @TranType = 501 OR @TranType = 404 OR @TranType = 405))
	SET @ret = 0;
RETURN ISNULL(@ret,0)
END
