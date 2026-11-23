
CREATE PROCEDURE spUpdateMaxFailNumber
	@ProgramId			INT
AS
BEGIN

update m set m.MaxFailNumber=MerchantMaxFailNumber
from Program pp with(nolock)
join Merchant m with(nolock) on m.ProgramId = pp.Id
where pp.Id = @ProgramId and m.MaxFailNumber<pp.MerchantMaxFailNumber

update m set m.MaxFailNumber=MerchantMaxFailNumber
from Program pp with(nolock)
join Shop m with(nolock) on m.ProgramId = pp.Id
where pp.Id = @ProgramId and m.MaxFailNumber<pp.MerchantMaxFailNumber

update m set m.MaxFailNumber=MerchantMaxFailNumber
from Program pp with(nolock)
join Terminal m with(nolock) on m.ProgramId = pp.Id
where pp.Id = @ProgramId and m.MaxFailNumber<pp.MerchantMaxFailNumber

END
