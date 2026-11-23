
CREATE function [dbo].[F_GetDiscountAmount](
    @FinanceFormulaType TINYINT , --1 prepaid, 2 postpaid, 3 Cost
    @FaceValue INT , --cent
    @TranType SMALLINT ,--
    @TranAmount INT ,
    @ProductType TINYINT , -- 1--product based, 2--Value based
    @SoldPrice NUMERIC(15, 4),
	@BalanceAvailable	int,
	@MGCType            CHAR     = 'G' --M:Master Voucher; G:General Vocher; C:Child Voucher
 ,@Instance			varchar(20)     = NULL
)
returns numeric(20,6)
as
begin
--101	Redemption
--201	ReverseRedemption
--103	Pre-Auth Complete
--203	Reverse Pre-Auth Complete
--401	Issue
--501	Reverse Issue
--404	Trash
--405   TrashNoMoney
DECLARE @ret AS NUMERIC(20, 6)
DECLARE @tax DECIMAL(10,5) = 1;
	 IF @Instance IS NOT NULL AND @Instance = 'TW'
	 BEGIN
	     SET @MGCType = 'G';
		 SET @tax = 1.05;
	 END
SELECT  @ret = 0

IF ( @FinanceFormulaType = 1 )
    BEGIN
        IF ( @ProductType = 1 )
            BEGIN
                IF ( @TranType = 401 )
                    SET @ret = (@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount
				IF ( @TranType = 501 )
                    SET @ret = (@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount * -1                         
                IF ( @TranType = 404 OR @TranType = 405 )
                    SET @ret = (@SoldPrice - @FaceValue * 1.000000/ 100)*@BalanceAvailable * -1
            END
        ELSE
            BEGIN
                IF ( @TranType = 401 )
                    SET @ret = case when @FaceValue = 0 then 0 else (@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount/100/(@FaceValue*@tax/100) end
				IF ( @TranType = 501 )
                    SET @ret = case when @FaceValue = 0 then 0 else (@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount/100/(@FaceValue*@tax/100) * -1 end
                IF ( @TranType = 404 OR @TranType = 405 )
                    SET @ret = case when @FaceValue = 0 then 0 else (@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount/100/(@FaceValue*@tax/100) * -1 end
            END
    END

IF ( @FinanceFormulaType = 2 )
    BEGIN

        IF ( @ProductType = 1 )
            BEGIN
                IF ( @TranType = 101 OR @TranType = 103 )
                    SET @ret = (@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount
                IF ( @TranType = 201 OR @TranType = 203 )
                    SET @ret = (@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount * -1      
            END
        ELSE
            BEGIN
                IF ( @TranType = 101 OR @TranType = 103 )
                    SET @ret = case when @FaceValue = 0 then 0 else (@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount/100/(@FaceValue*@tax/100) end
                IF ( @TranType = 201 OR @TranType = 203 )
                    SET @ret = case when @FaceValue = 0 then 0 else (@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount/100/(@FaceValue*@tax/100) * -1 end
            END
    END
IF(@MGCType = 'M'  AND (@TranType = 101 OR @TranType = 201 OR @TranType = 103 OR @TranType = 203))
	SET @ret = 0;
IF(@MGCType = 'C' AND (@TranType = 401 OR @TranType = 501 OR @TranType = 404 OR @TranType = 405))
    SET @ret = 0;
RETURN ISNULL(@ret,0)
end
