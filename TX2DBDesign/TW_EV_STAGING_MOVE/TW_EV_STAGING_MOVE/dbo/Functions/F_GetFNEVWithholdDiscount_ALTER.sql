


CREATE function [dbo].[F_GetFNEVWithholdDiscount_ALTER](
@FinanceFormulaType tinyint, 	--1 prepaid, 2 postpaid, 3 Cost
@FaceValue          numeric(15,4), 		--cent
@SoldPrice			numeric(15,4),		--not cent   (@SoldPrice - @FaceValue * 1.000000 / 100)
@TranType           smallint,
@ProductType        tinyint, 	-- 1--product based, 2--Value based
@TranAmount			numeric(15,4),
@PreTranType		INT,
@InitBalance		INT,		-- Adora.Account.BalanceInitialized
@LEInitBalance		INT		-- The current BalanceAvailable when just enter into L&E.
)
returns numeric(20,6)
as
begin
	declare @ret as numeric(20,6)

	select @ret = 0

	if(@FinanceFormulaType =1)
	begin
		if(@ProductType=1)
		begin
			if(@TranType = 116 AND (@PreTranType = 201 OR @PreTranType = 203)) 
				set @ret = (@SoldPrice-@FaceValue*1.000000/100)*@TranAmount
			else if(@TranType = 117 AND (@PreTranType = 101 OR @PreTranType = 103)) 
				set @ret = (@SoldPrice-@FaceValue*1.000000/100)*@TranAmount * -1
			else if(@TranType = 117 AND (@PreTranType = 404))
				set @ret = (@SoldPrice - @FaceValue * 1.000000/100)*@LEInitBalance*1.000000 * -1;
		end
		else if (@ProductType=2)
		begin
			if(@TranType = 116 AND (@PreTranType = 201 OR @PreTranType = 203)) 	
				SET @ret = case when @FaceValue = 0 then 0 else round((@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount/round(@FaceValue*1.05, 2), 4) end
			else if(@TranType = 117 AND (@PreTranType = 101 OR @PreTranType = 103)) 
				SET @ret = case when @FaceValue = 0 then 0 else round((@SoldPrice - @FaceValue * 1.000000/ 100)*@TranAmount/round(@FaceValue*1.05, 2), 4) end * -1;
			else if(@TranType = 117 AND (@PreTranType = 404))
				SET @ret = case when @FaceValue = 0 then 0 else round((@SoldPrice - @FaceValue * 1.000000/ 100)*@LEInitBalance/round(@FaceValue*1.05, 2), 4) end * -1;		
		end
	end

	return isnull(@ret,0)
end
