
CREATE function [dbo].[F_GetCostMarketingAmount](
@FinanceFormulaType tinyint, --1 prepaid, 2 postpaid, 3 Cost Marketing, 4 Cost-Employee Welfare, 5 Cost-Test
@ContractAmount numeric(15,4),
@TranType           smallint,--
@TranAmount         int,
@ProductType        tinyint, -- 1--product based, 2--Value based
@MGCType            CHAR = 'G' --M:Master Voucher; G:General Vocher; C:Child Voucher
,@Instance			varchar(20)     = NULL
 )
returns numeric(20,6)
as
begin
--403	Expire
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

	if(@FinanceFormulaType=3)
	begin
	  if(@ProductType=1)
	    set @ret = @ContractAmount*@TranAmount
	  else
	    set @ret = @ContractAmount*@TranAmount*1.000000/10000/@tax
	end
	return isnull(@ret,0)
end
