CREATE proc [quotation].[sp_get_quotation_child_products]
(
  @quotation_id int
)
as
begin
select qp.id as quotation_product_id
,qp.product_version_id
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
,qpc.customization_product_id
,qpc.product_combos_set_id
,qpc.business_model_id
,qpc.sequence
,qpc.quotation_product_id as master_quotation_product_id
from tb_qm_quotation_map map with(nolock)
join tb_q_quotation q with(nolock) on map.child_quotation_id = q.id
join tb_qp_quotation_product qp with(nolock) on q.id= qp.quotation_id
join tb_qpsp_quotation_product_sold_price qpsp with(nolock) on qpsp.quotation_product_id = qp.id
join tb_qpc_quotation_product_combo qpc with(nolock) on qpc.child_client_quotation_product_id = qp.id
where map.master_quotation_id = @quotation_id and q.created_by_system =1
end