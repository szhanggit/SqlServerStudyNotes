

CREATE function [dbo].[F_GetIEVAmount](
@FinanceFormulaType tinyint, --1 prepaid, 2 postpaid, 3 Cost
@FaceValue          int, --cent
@TranType           smallint,--
@TranAmount         int,
@ProductType        tinyint, -- 1--product based, 2--Value based
@MGCType            CHAR = 'G' --M:Master Voucher; G:General Vocher; C:Child Voucher
,@Instance			varchar(20)     = NULL
)
returns numeric(20,6)
as
begin
--101	Redeem
--201	Reverse Redeem
--103	Pre-Auth Complete
--203	Reverse Pre-Auth Complete
--401	Issue
--501	Reverse Issue
--404	Trash
--405   TrashNoMoney
--503	ReverseExpire
	declare @ret as numeric(20,6)
	DECLARE @tax DECIMAL(10,5) = 1;
	 IF @Instance IS NOT NULL AND @Instance = 'TW'
	 BEGIN
	     SET @MGCType = 'G';
		 SET @tax = 1.05;
	 END
	select @ret = 0

	if(@FinanceFormulaType =2)
	begin
	  if(@ProductType=1)
		begin
			if(@TranType=403) 
				set @ret = @FaceValue * @TranAmount * 1.000000/100
			else if(@TranType=503) 
				set @ret = @FaceValue * @TranAmount *-1.000000/100
		end
		else if (@ProductType=2)
		begin
		  if(@TranType=403) 
				set @ret = @TranAmount*1.000000/100/@tax
			else if(@TranType=503) 
				set @ret = @TranAmount*-1.000000/100/@tax
		end
	end
	IF(@MGCType = 'M' AND (@TranType = 101 OR @TranType = 201 OR @TranType = 103 OR @TranType = 203))
			SET @ret = 0;
    IF(@MGCType = 'C' AND (@TranType = 401 OR @TranType = 501 OR @TranType = 404 OR @TranType = 405))
        SET @ret = 0;
	return isnull(@ret,0)
end
