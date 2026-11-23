CREATE PROCEDURE [product].[sp_sel_time_restriction_list]
    @product_id int
AS
BEGIN
	IF(@product_id > 0)
    BEGIN
		select rs.day_of_week as DayOfTheWeek
		, rs.start_time as StartTime
		, rs.end_time as EndTime
		, p.redeem_time_restriction_id as ProductRedeemTimeRestrictionId
		, rs.product_redeem_time_restriction_set_id as ProductRedeemTimeRestrictionSetId
		from [product].[tb_p_product] p with(nolock)
		inner join [product].[tb_p_product_redeem_time_restriction] r with(nolock) on p.redeem_time_restriction_id = r.product_redeem_time_restriction_id
		inner join [product].[tb_p_product_redeem_time_restriction_set] rs with(nolock) on rs.product_redeem_time_restriction_id = r.product_redeem_time_restriction_id
		where p.product_id = @product_id
    END	
END