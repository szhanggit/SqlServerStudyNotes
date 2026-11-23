
CREATE PROCEDURE dbo.TMP_TestQueryMerchant
AS   
    declare @n int = 100;
	declare @cnt int = 0;

	while @cnt < @n
	begin
		select id, security_key, program_id, status
		from merchant_info.tb_m_merchant
		where identity_code = '000000000000032'

		set @cnt = @cnt + 1;
end
