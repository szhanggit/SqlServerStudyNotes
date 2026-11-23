




CREATE function [dbo].[F_GetFNEVDiscount_ALTER](
@FinanceFormulaType tinyint, 	--1 prepaid, 2 postpaid, 3 Cost
@FaceValue          numeric(15,4), 		--cent
@SoldPrice			numeric(15,4),		--not cent   (@SoldPrice - @FaceValue * 1.000000 / 100)
@TranType           smallint,
@ProductType        tinyint, 	-- 1--product based, 2--Value based
@PreTranType		INT,
@LEInitBalance		INT,
@MultipleSelectionType INT
)
returns numeric(20,6)
as
begin
    declare @ret as numeric(20,6);
    select @ret = 0;

    IF ( @FinanceFormulaType = 1 AND (@MultipleSelectionType=0 OR @MultipleSelectionType=2))
		BEGIN
			IF ( @ProductType = 1 )
				BEGIN
					if(@TranType = 116 AND @PreTranType = 402) 
                set @ret = (@SoldPrice-@FaceValue*1.000000/100)*@LEInitBalance
            else if(@TranType = 117 AND (@PreTranType = 404 OR @PreTranType = 405)) 
                set @ret = (@SoldPrice-@FaceValue*1.000000/100)*@LEInitBalance * -1
				END
			ELSE
				BEGIN
					if(@TranType = 116 AND @PreTranType = 402) 
						SET @ret = case when @FaceValue = 0 then 0 else round((@SoldPrice - @FaceValue * 1.000000/ 100)*@LEInitBalance/round(@FaceValue*1.05, 2), 4) end
					else if(@TranType = 117 AND (@PreTranType = 404 OR @PreTranType = 405)) 
						SET @ret = case when @FaceValue = 0 then 0 else round((@SoldPrice - @FaceValue * 1.000000/ 100)*@LEInitBalance/round(@FaceValue*1.05, 2), 4) end
				END
		END
	 IF ( @FinanceFormulaType = 1 AND @MultipleSelectionType=1)
		BEGIN
			IF ( @ProductType = 1 )
				BEGIN
					if(@TranType = 116 AND @PreTranType = 402) 
						set @ret = (@SoldPrice-@FaceValue*1.000000/100)*@LEInitBalance
					else if(@TranType = 117 AND (@PreTranType = 404 OR @PreTranType = 405)) 
						set @ret = (@SoldPrice-@FaceValue*1.000000/100)*@LEInitBalance * -1
				END
			ELSE
				BEGIN
					if(@TranType = 116 AND @PreTranType = 402) 
						SET @ret = case when @FaceValue = 0 then 0 else round((@SoldPrice - @FaceValue * 1.000000/ 100)*@LEInitBalance/round(@FaceValue*1.05, 2), 4) end
					else if(@TranType = 117 AND (@PreTranType = 404 OR @PreTranType = 405)) 
						SET @ret = case when @FaceValue = 0 then 0 else round((@SoldPrice - @FaceValue * 1.000000/ 100)*@LEInitBalance/round(@FaceValue*1.05, 2), 4) end
				END
		END

    return isnull(@ret,0);
end
