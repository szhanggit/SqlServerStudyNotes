CREATE PROCEDURE [order].[sp_get_order_activate_mode]
	@order_id int

AS
BEGIN
    
select id,
order_id,
mode,
after_published,
fix_date 
from tb_oam_order_activate_mode with(nolock)
 where order_id = @order_id

END