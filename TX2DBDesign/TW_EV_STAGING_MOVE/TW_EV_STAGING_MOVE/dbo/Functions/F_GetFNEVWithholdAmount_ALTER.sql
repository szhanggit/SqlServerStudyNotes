

CREATE function [dbo].[F_GetFNEVWithholdAmount_ALTER](
@FinanceFormulaType tinyint, --1 prepaid, 2 postpaid, 3 Cost
@FaceValue          int, --cent
@TranType           smallint,--
@ProductType        tinyint, -- 1--product based, 2--Value based
@TranAmount			INT,
@PreTranType		INT,
@InitBalance		INT,
@LEBalance		INT
)
returns numeric(20,6)
as
begin
--503	ReverseExpire
--403	Expire
	declare @ret as numeric(20,6)

	select @ret = 0

	if(@FinanceFormulaType =1)
	begin
		if(@ProductType=1)
		begin
			if(@TranType = 116 AND (@PreTranType = 201 OR @PreTranType = 203)) 
				set @ret = @FaceValue*1.000000/100*@TranAmount
			else if(@TranType = 117 AND (@PreTranType = 101 OR @PreTranType = 103)) 
				set @ret = @FaceValue*1.000000/100*@TranAmount * -1
			else if(@TranType = 117 AND @PreTranType = 404) 
				set @ret = @FaceValue*1.000000/100*@LEBalance * -1
		end
		else if (@ProductType=2)
		begin
			if(@TranType = 116 AND (@PreTranType = 201 OR @PreTranType = 203)) 
				SET @ret = case when @FaceValue = 0 then 0 else round((@FaceValue * 1.000000/ 100)*@TranAmount/round(@FaceValue*1.05, 2), 4) end
			else if(@TranType = 117 AND (@PreTranType = 101 OR @PreTranType = 103)) 
				SET @ret = case when @FaceValue = 0 then 0 else round((@FaceValue * 1.000000/ 100)*@TranAmount/round(@FaceValue*1.05, 2), 4) end * -1
			else if(@TranType = 117 AND @PreTranType = 404) 
				SET @ret = case when @FaceValue = 0 then 0 else round((@FaceValue * 1.000000/ 100)*@LEBalance/round(@FaceValue*1.05, 2), 4) end * -1
		end
	end

	return isnull(@ret,0)
	
end

 

