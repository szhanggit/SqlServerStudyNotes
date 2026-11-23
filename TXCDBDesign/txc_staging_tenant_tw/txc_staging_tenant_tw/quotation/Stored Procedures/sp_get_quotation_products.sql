CREATE proc [quotation].[sp_get_quotation_products]
(
  @quotation_id int
)
as
begin
  select qp.id as quotation_product_id
, qp.product_version_id
,qp.expiry_scheme_id
,qp.max_issue_voucher_number
,qp.expiration_date
,qp.[status]
,qpsp.sold_price
,qpsp.sold_price_with_tax
,qpsp.sold_price_percentage
,qpsp.face_value_range_from
,qpsp.face_value_range_to
,qpsp.[status] as price_status
from tb_qp_quotation_product qp with(nolock)
join tb_qpsp_quotation_product_sold_price qpsp with(nolock) on qpsp.quotation_product_id = qp.id
join tb_q_quotation q with(nolock) on q.id = qp.quotation_id
where qp.quotation_id = @quotation_id and q.created_by_system <> 1
end