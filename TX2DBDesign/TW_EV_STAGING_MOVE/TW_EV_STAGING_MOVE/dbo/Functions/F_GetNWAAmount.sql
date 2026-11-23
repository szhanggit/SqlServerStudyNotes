
CREATE function [dbo].[F_GetNWAAmount](
@FinanceFormulaType tinyint, --1 prepaid, 2 postpaid, 3 Cost
@FaceValue          int, --cent
@TranType           smallint,--
@TranAmount         int,
@ProductType        tinyint, -- 1--product based, 2--Value based
@Cost               numeric(15,4),
@ContractAmount     numeric(15,4),
@BalanceAvailable	int,
@MGCType CHAR = 'G' --M:Master Voucher; G:General Vocher; C:Child Voucher
,@Instance			varchar(20)     = NULL
)
returns numeric(20,6)
as
begin
--Redemption = 101,
--ReverseRedemption = 201,
--PreAuthorization = 102,
--ReversePreAuthorization = 202,
--PreAuthorizationComplete = 103,
--ReversePreAuthorizationComplete = 203,
--AccountVerification = 104,
--BalanceEnquiry = 105,
--PosTest = 301,
--Issue = 401,
--ReverseIssue = 501,
--Activate = 402,
--ReverseActivate = 502,
--Expire = 403,
--ReverseExpire = 503,
--Extend = 504,
--PreAuthorizationExpire = 106,
--Reload = 107,
--ReverseReload = 207,
--TrashMoney = 404,
--TrashNoMoney = 405,
--ReverseFailedPreAuthorizationComplete = 603,
--FinanceExpire=116,
--ReverseFinanceExpire=117
	declare @ret as numeric(20,6)
	 DECLARE @tax DECIMAL(10,5) = 1;
	 IF @Instance IS NOT NULL AND @Instance = 'TW'
	 BEGIN
	     SET @MGCType = 'G';
		 SET @tax = 1.05;
	 END
	select @ret = 0

	if(@FinanceFormulaType =1)
	begin
	  if(@ProductType=1)
		begin
			if(@TranType in (401,201,203)) 
				set @ret = (@FaceValue*1.000000/100-@Cost)*@TranAmount
            if(@TranType = 501) 
				set @ret = ((@FaceValue*1.000000/100-@Cost)*@TranAmount) * -1
			else if(@TranType in (101,103)) 
				set @ret = (@Cost-@FaceValue*1.000000/100)*@TranAmount					
			else if(@TranType in (503)) 
				set @ret = (@FaceValue*1.000000/100-@Cost)*@BalanceAvailable			
			else if(@TranType in (403,404,405)) 
				set @ret = (@Cost-@FaceValue*1.000000/100)*@BalanceAvailable
		end
		else if (@ProductType=2)
		begin
			if(@TranType = 401) 
				set @ret = @FaceValue*(100-@Cost)*1.000000/10000
			if(@TranType = 501) 
				set @ret = (@FaceValue*(100-@Cost)*1.000000/10000) * -1
			else if (@TranType = 101 OR @TranType = 103)
			  set @ret = @TranAmount*(@Cost-100)*1.000000/10000/@tax
			else if (@TranType = 201 OR @TranType = 203)
			  set @ret = @TranAmount*(100-ABS(@Cost))*1.000000/10000/@tax
			else if (@TranType in (403,404,405))
			  set @ret = @TranAmount*(@Cost-100)*1.000000/10000/@tax
			else if(@TranType = 503) 
				set @ret = @TranAmount*(100-@Cost)*1.000000/10000/@tax
		end
	end
	IF(@MGCType = 'M' AND (@TranType = 101 OR @TranType = 201 OR @TranType = 103 OR @TranType = 203))
			SET @ret = 0;
    IF(@MGCType = 'C' AND (@TranType = 401 OR @TranType = 501 OR @TranType = 404 OR @TranType = 405))
        SET @ret = 0;
	return isnull(@ret,0)
end
