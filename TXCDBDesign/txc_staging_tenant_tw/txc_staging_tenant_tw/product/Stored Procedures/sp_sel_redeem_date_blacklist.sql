CREATE PROCEDURE [product].[sp_sel_redeem_date_blacklist]
    @product_id int
AS
BEGIN
	IF(@product_id > 0)
    BEGIN
		select 
		bset.product_redeem_date_blacklist_set_id as ProductRedeemDateBlacklistSetId
		, bset.product_redeem_date_blacklist_id as ProductRedeemDateBlacklistId
		, bset.black_date as BlackDate
		from product.tb_p_product p with(nolock)
		inner join [product].tb_p_product_redeem_date_blacklist b with(nolock) on p.redeem_date_blacklist_id = b.product_redeem_date_blacklist_id
		inner join [product].tb_p_product_redeem_date_blacklist_set bset with(nolock) on bset.product_redeem_date_blacklist_id = b.product_redeem_date_blacklist_id
		where p.product_id = @product_id
    END	
END