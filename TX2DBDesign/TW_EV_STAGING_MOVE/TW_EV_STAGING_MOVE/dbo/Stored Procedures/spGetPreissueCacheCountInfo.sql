CREATE PROCEDURE [dbo].[spGetPreissueCacheCountInfo] 
AS
BEGIN
	SET NOCOUNT ON;

--select CacheKey from (
--select CONCAT(b.ProductId , '=' , b.ReservationCodeId) as CacheKey
--,count(case when p.Status = 2 then 1 else null end) as VoucherIssueCount
--,count(case when p.Status = 256 then 1 else null end) as VoucherCacheCount from PreIssueVoucherInfo p with(nolock)
--join PreIssueBatchInfo b with(nolock) on b.Id = p.BatchInfoId
--where p.Status in (2,256) and p.ExpiryDate>GETDATE()
--group by b.ProductId,b.ReservationCodeId
--having count(case when p.Status = 2 then 1 else null end)>0 or count(case when p.Status = 256 then 1 else null end)>600) as temp
--where VoucherCacheCount >0
--order by VoucherIssueCount desc
BEGIN TRAN 
 BEGIN TRY
delete  LoadCacheInfo

insert into LoadCacheInfo
select CacheKey from (
select CONCAT(b.ProductId , '=' , b.ReservationCodeId) as CacheKey
,count(case when p.Status = 2 then 1 else null end) as VoucherIssueCount
,count(case when p.Status = 256 then 1 else null end) as VoucherCacheCount from PreIssueVoucherInfo p  with(nolock) 
join PreIssueBatchInfo b with(nolock) on b.Id = p.BatchInfoId
where p.Status in (2,256) and p.ExpiryDate>GETDATE()
group by b.ProductId,b.ReservationCodeId
having count(case when p.Status = 2 then 1 else null end)>0) as temp
where VoucherCacheCount >0
order by VoucherIssueCount desc

insert into LoadCacheInfo
select CacheKey from (
select CONCAT(b.ProductId , '=' , b.ReservationCodeId) as CacheKey
,count(case when p.Status = 256 then 1 else null end) as VoucherCacheCount
,b.ProductId
,b.ReservationCodeId
from PreIssueVoucherInfo p  with(nolock) 
join PreIssueBatchInfo b with(nolock) on b.Id = p.BatchInfoId
where p.Status in(2,256) and p.ExpiryDate>GETDATE()
group by b.ProductId,b.ReservationCodeId
having count(case when p.Status = 2 then 1 else null end)=0 and count(case when p.Status = 256 then 1 else null end)>0) as temp
join Voucher v with(nolock) on v.ProductId = temp.ProductId
join VoucherReservationBatch vb with(nolock) on vb.Id = v.ReservationBatchId
join OrderBeneficiaryInfo obi with(nolock) on obi.Id = v.BeneficiaryInfoId
join OrderLine ol with(nolock) on ol.Id = obi.OrderLineId
join [Order] o on o.Id = ol.OrderId
where VoucherCacheCount >0 and o.Mode in( 2,32) and vb.VoucherReservationCodeId = temp.ReservationCodeId and v.Status = 2 and v.ActivatedOn>DATEADD(DAY,-90,GETDATE())
group by temp.CacheKey
order by max(v.ActivatedOn) desc
END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
select CacheKey from LoadCacheInfo WITH(NOLOCK) ORDER BY Id
END