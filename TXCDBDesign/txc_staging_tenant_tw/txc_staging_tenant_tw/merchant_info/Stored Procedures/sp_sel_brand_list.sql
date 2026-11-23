CREATE PROCEDURE [merchant_info].[sp_sel_brand_list] 
     @row_count int = 20,  
	@page_offset int = 0,  
	@search_key_word NVARCHAR(100)='',  
	@brand_id INT = 0,  
	@accurate_brand_name_search bit,
	@total_count int = 0 OUTPUT  
AS  
BEGIN  

set @search_key_word=isnull(@search_key_word,'')
if(@row_count=0)
begin
set @row_count=20
END
	if(@brand_id>0 or @accurate_brand_name_search=1)
	BEGIN
		SELECT b.id AS BrandId,  
		 b.brand_name As BrandName,	  
		 b.media_id AS MediaId, 	   
		 b.status AS BrandStatus,
		 b.created_by AS CreatedBy
		 FROM [merchant_info].[tb_b_brand] AS b with(nolock)  	 
		 where b.id = @brand_id or b.brand_name =@search_key_word
		 order by b.id
			OFFSET @page_offset ROWS  
		FETCH NEXT @row_count ROWS ONLY 	
		SET @total_count = @@ROWCOUNT
	END
	ELSE
	BEGIN
		SELECT b.id AS BrandId,  
		 b.brand_name As BrandName,	  
		 b.media_id AS MediaId, 	   
		 b.status AS BrandStatus,
		 b.created_by AS CreatedBy
		 FROM [merchant_info].[tb_b_brand] AS b with(nolock)  	 
		 where (b.id = @brand_id or @brand_id=0) and (b.brand_name LIKE '%'+@search_key_word+'%' or @search_key_word='')
		 order by b.id
			OFFSET @page_offset ROWS  
		FETCH NEXT @row_count ROWS ONLY 

		SET @total_count = (select count(1) FROM [merchant_info].[tb_b_brand] AS b with(nolock)  	 
		 where (b.id = @brand_id or @brand_id=0) and (b.brand_name LIKE '%'+@search_key_word+'%' or @search_key_word='')) 
	END   
END