
CREATE function [dbo].[F_GetFNNWAAmount](
@FinanceFormulaType tinyint, 	--1 prepaid, 2 postpaid, 3 Cost
@FaceValue          int, 		--cent
@SoldPrice			int,		--not cent   (@SoldPrice - @FaceValue * 1.000000 / 100)
@TranType           smallint,
@ProductType        tinyint, 	-- 1--product based, 2--Value based
@TranAmount			INT,
@PreTranType		INT,
@InitBalance		INT,		-- Adora.Account.BalanceInitialized
@LEInitBalance		INT,		-- The current BalanceAvailable when just enter into L&E.
@BalanceAvailable	INT,
@Cost               numeric(15,4)
)
returns numeric(20,6)
as
begin
--401	Issue
--404	TrashMoney
--405	TrashNoMoney
--101	Redemption
--201	ReverseRedemption
--503	ReverseExpire
--403	Expire
	declare @ret as numeric(20,6) = 0;

	if(@FinanceFormulaType =1)
	begin
	  if(@ProductType=1)
		begin
			if(@TranType = 116 AND @PreTranType = 402)
				set @ret = (@FaceValue*1.000000/100-@Cost)*@LEInitBalance*-1;	
			else if(@TranType = 116 AND @PreTranType in (201, 203)) 
				set @ret = (@FaceValue*1.000000/100-@Cost)*@TranAmount*-1;
			else if(@TranType = 117 AND @PreTranType in (101, 103, 404)) 
				set @ret = (@FaceValue*1.000000/100-@Cost)*@TranAmount;
		end
		else if (@ProductType=2)
		begin
			if(@TranType = 116 AND @PreTranType = 402) 
			  set @ret = (@FaceValue*1.000000/100-@FaceValue*@Cost/10000)*@LEInitBalance/@InitBalance*-1;
			else if(@TranType = 116 AND @PreTranType in (201, 203)) 
				set @ret = (@FaceValue*1.000000/100-@FaceValue*@Cost/10000)*@TranAmount/@InitBalance*-1;
			else if(@TranType = 117 AND @PreTranType in (101, 103, 404)) 
				set @ret = (@FaceValue*1.000000/100-@FaceValue*@Cost/10000)*@TranAmount/@InitBalance;

		end
	end

	return isnull(@ret,0)
end
