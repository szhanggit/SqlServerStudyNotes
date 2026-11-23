CREATE proc [quotation].[sp_get_quotation_product_by_product_code]
(
  @QuotationId int,
  @ProductCode nvarchar(100)
)
as
begin
  select top 1 id as quotation_product_id
, product_version_id
,expiry_scheme_id
,max_issue_voucher_number
,expiration_date
,[status]
from tb_qp_quotation_product with(nolock)
where quotation_id = @QuotationId and product_code = @ProductCode
end