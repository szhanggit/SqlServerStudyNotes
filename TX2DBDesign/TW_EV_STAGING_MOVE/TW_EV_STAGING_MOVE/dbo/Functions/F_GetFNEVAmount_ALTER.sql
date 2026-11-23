

CREATE function [dbo].[F_GetFNEVAmount_ALTER](
@FinanceFormulaType tinyint, --1 prepaid, 2 postpaid, 3 Cost
@FaceValue          int, --cent
@TranType           smallint,--
@ProductType        tinyint, -- 1--product based, 2--Value based
@BalanceAvailable	INT,
@PreTranType		INT,
@InitBalance		INT,
@LEBalance			INT
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
            if(@TranType = 116 AND @PreTranType = 402) 
                set @ret = @FaceValue*1.000000/100*@BalanceAvailable
            else if(@TranType = 117 AND (@PreTranType = 404 OR @PreTranType = 405)) 
                set @ret = @FaceValue*1.000000/100*@LEBalance * -1
        end
        else if (@ProductType=2)
        begin
            if(@TranType = 116 AND @PreTranType = 402) 
				SET @ret = case when @FaceValue = 0 then 0 else round((@FaceValue * 1.000000/ 100)*@BalanceAvailable/round(@FaceValue*1.05, 2), 4) end
            else if(@TranType = 117 AND (@PreTranType = 404 OR @PreTranType = 405)) 
                SET @ret = case when @FaceValue = 0 then 0 else round((@FaceValue * 1.000000/ 100)*@LEBalance/round(@FaceValue*1.05, 2), 4) end * -1
        end
    end

    return isnull(@ret,0)
end

 

