CREATE FUNCTION [dbo].[F_GetFNEVDiscount](
@FinanceFormulaType tinyint, 	--1 prepaid, 2 postpaid, 3 Cost
@FaceValue          numeric(15,4), 		--cent
@SoldPrice			numeric(15,4),		--not cent   (@SoldPrice - @FaceValue * 1.000000 / 100)
@TranType           smallint,
@ProductType        tinyint, 	-- 1--product based, 2--Value based
@PreTranType		INT,
@LEInitBalance		INT			-- The current BalanceAvailable when just enter into L&E.
,@Instance			varchar(20)     = NULL
)
returns numeric(20,6)
as
begin
    declare @ret as numeric(20,6);
    select @ret = 0;
	DECLARE @tax DECIMAL(10,5) = 1;
	 IF @Instance IS NOT NULL AND @Instance = 'TW'
	 BEGIN
		 SET @tax = 1.05;
	 END

    if(@FinanceFormulaType =1)
    begin
        if(@ProductType=1)
        begin
            if(@TranType = 116 AND @PreTranType = 402) 
                set @ret = (@SoldPrice - @FaceValue * 1.000000/100) * @LEInitBalance;
            else if(@TranType = 117 AND @PreTranType = 404)
                set @ret = (@FaceValue * 1.000000/100 - @SoldPrice) * @LEInitBalance;
        end
        else if (@ProductType=2)
        begin
            if(@TranType = 116 AND @PreTranType = 402) 
                set @ret = (@SoldPrice - @FaceValue * 1.000000/100)*@LEInitBalance/@FaceValue/@tax;		
				--TotalDiscount/BalanceInitialized = (SoldPrice-FV)/FV => TotalDiscount = (SoldPrice-FV)*BalanceInitialized/FV
				--ActivatedDiscount/TotalDiscount = LEInitBalance/BalanceInitialized => ActivatedDiscount = LEInitBalance*TotalDiscount/BalanceInitialized
				--ActivatedDiscount = LEInitBalance*(SoldPrice-FV)*BalanceInitialized/FV/BalanceInitialized = LEInitBalance*(SoldPrice-FV)/FV				
            else if(@TranType = 117 AND @PreTranType = 404) 
                set @ret = (@FaceValue * 1.000000/100 - @SoldPrice)*@LEInitBalance/@FaceValue/@tax;
        end
    end

    return isnull(@ret,0);
end
