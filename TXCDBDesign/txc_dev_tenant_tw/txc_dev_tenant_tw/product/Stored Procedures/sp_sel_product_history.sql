CREATE PROCEDURE [product].[sp_sel_product_history]

	-- Add the parameters for the stored procedure here
    @ProductId int,
	@TotalCount int = 0 OUTPUT
AS
begin 
Select  pv.product_version_id as ProductVersionId,
		pv.version as Version,
		product_code as ProductCode,
		pv.product_name as ProductName,
		product_type as ProductType,
		status as Status,
		pv.created_by as CreatedBy,
		pv.created_on as CreatedOn,
		pv.last_updated_by as LastUpdatedBy,
		pv.last_updated_on as LastUpdatedOn
		from product.tb_p_product_version pv with(nolock)
		inner join product.tb_p_product p on p.product_id = pv.product_id
		where pv.product_id = @ProductId

		SET @TotalCount = @@ROWCOUNT
end