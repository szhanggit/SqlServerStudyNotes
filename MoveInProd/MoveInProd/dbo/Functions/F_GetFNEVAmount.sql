
CREATE function [dbo].[F_GetFNEVAmount](
@FinanceFormulaType tinyint, --1 prepaid, 2 postpaid, 3 Cost
@FaceValue          int, --cent
@TranType           smallint,--
@ProductType        tinyint, -- 1--product based, 2--Value based
@PreTranType		INT,
@LEInitBalance		INT,			-- The current BalanceAvailable when just enter into L&E.
@Instance			varchar(20)     = NULL
)
returns numeric(20,6)
as
begin
--503	ReverseExpire
--403	Expire
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
                set @ret = @FaceValue*@LEInitBalance*1.000000/100;
            else if(@TranType = 117 AND @PreTranType = 404)
                set @ret = @FaceValue*@LEInitBalance*-1.000000/100;
        end
        else if (@ProductType=2)
        begin
            if(@TranType = 116 AND @PreTranType = 402) 
                set @ret = @LEInitBalance*1.000000/100/@tax;
            else if(@TranType = 117 AND @PreTranType = 404) 
                set @ret = @LEInitBalance*-1.000000/100/@tax;
        end
    end

    return isnull(@ret,0);
end
