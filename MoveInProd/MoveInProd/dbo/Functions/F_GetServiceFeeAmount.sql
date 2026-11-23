
CREATE function [dbo].[F_GetServiceFeeAmount](
@ServiceFeeType smallint, --401 issue,101 redemption
@SystemProcessFee numeric(15,4), --
@TranType smallint--cent
)
returns numeric(20,6)
as
begin

	declare @ret as numeric(20,6)

	select @ret = 0

	if(@ServiceFeeType = @TranType)
	    set @ret = @SystemProcessFee

	return isnull(@ret,0)
end


