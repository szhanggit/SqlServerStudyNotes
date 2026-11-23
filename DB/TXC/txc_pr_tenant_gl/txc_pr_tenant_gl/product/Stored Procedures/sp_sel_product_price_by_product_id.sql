CREATE PROCEDURE product.sp_sel_product_price_by_product_id
@ProductId as int
AS
begin 
		select
			pp.product_price_id,
			pp.selling_price_prepaid,
			pp.selling_price_prepaid_with_tax,
			pp.selling_price_postpaid,
			pp.selling_price_postpaid_with_tax,
			pp.customer_fee_prepaid,
			pp.customer_fee_prepaid_with_tax,
			pp.customer_fee_postpaid,
			pp.customer_fee_postpaid_with_tax
		from product.tb_p_product p with(nolock)
		inner join product.tb_p_product_price pp with(nolock) on p.price_id = pp.product_price_id
		where p.product_id = @ProductId
end