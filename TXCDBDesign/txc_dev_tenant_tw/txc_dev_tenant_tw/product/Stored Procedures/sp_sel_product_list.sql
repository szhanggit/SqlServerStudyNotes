CREATE PROCEDURE [product].[sp_sel_product_list]
	-- Add the parameters for the stored procedure here
    @Keyword NVARCHAR(500) = null,
	@Type int,
	@MerchantAcquirerId int,
	@RowCount int,
	@SortBy NVARCHAR(50),
	@SortDirection NVarchar(10),
	@PageOffset int,
	@Status int,
	@TotalCount int = 0 OUTPUT
AS
BEGIN


	CREATE TABLE #Tmp( product_id int NOT NULL );
												
	INSERT INTO #Tmp SELECT p.[product_id] From [product].[tb_p_product] p with(nolock) 
			where ([status] = @Status)
			and (@Type = 0 or [product_type] = @Type )
			and (@MerchantAcquirerId = 0 OR (@MerchantAcquirerId <> 0 AND voucher_issuer_id = @MerchantAcquirerId))
			and  
				(
				@Keyword is null or(
					[product_name]  like '%'+@Keyword +'%' or 
					[product_code] like '%'+@Keyword +'%' or
					[external_product_code] like '%'+@Keyword +'%' or
					[description] like '%'+@Keyword +'%' or
					[created_by] like '%'+@Keyword +'%'
					)
				);                    

	select	p.[product_id] as ProductId, 
			p.[product_code] as ProductCode,
			p.[product_name] as ProductName,
			p.[sku_id] as SkuId,
			p.[product_type] as ProductType,
			p.[created_by] as CreatedBy, 
			p.[created_on] as CreatedOn, 
			p.[status] as Status,
			p.program_id AS ProgramId,
			p.voucher_issuer_id AS MerchantAcquirerId
			From [product].[tb_p_product] p with(nolock) inner join #Tmp t On p.product_id = t.product_id			
			Order BY
			CASE WHEN @SortBy ='product_name' AND  @SortDirection = 'ASC' THEN [product_name]END ASC ,
			CASE WHEN @SortBy ='product_name' AND  @SortDirection = 'DESC' THEN [product_name]END DESC ,
			CASE WHEN @SortBy ='product_code' AND  @SortDirection = 'ASC' THEN [product_code]END ASC ,
			CASE WHEN @SortBy ='product_code' AND  @SortDirection = 'DESC' THEN [product_code]END DESC ,
			CASE WHEN @SortBy ='product_type' AND  @SortDirection = 'ASC' THEN [product_type] END ASC ,
			CASE WHEN @SortBy ='product_type' AND  @SortDirection = 'DESC' THEN [product_type] END DESC,
			CASE WHEN @SortBy ='status' AND  @SortDirection = 'ASC' THEN [status] END ASC,
			CASE WHEN @SortBy ='status' AND  @SortDirection = 'DESC' THEN [status] END DESC ,
			CASE WHEN @SortBy ='created_on' AND  @SortDirection = 'ASC' THEN [created_on] END ASC,
			CASE WHEN @SortBy ='created_on' AND  @SortDirection = 'DESC' THEN [created_on] END DESC
			OFFSET @PageOffset ROWS 
			FETCH NEXT @RowCount ROWS ONLY 

			SET @TotalCount = (select count(1) from #Tmp);
			drop table #Tmp;

END