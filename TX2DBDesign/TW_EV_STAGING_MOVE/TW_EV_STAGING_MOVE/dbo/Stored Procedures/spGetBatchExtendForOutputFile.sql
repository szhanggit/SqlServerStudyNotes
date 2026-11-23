CREATE PROCEDURE [dbo].[spGetBatchExtendForOutputFile]
	 AS  
	BEGIN  
	
	
select distinct
	be.Id, 
	FileName,
	CreatedTime,
	be.TotalRows,
	SuccessRows,
	ErrorRows,
	be.[Status],
	BatchTransactionId
from BatchExtend be with(nolock) 
	left join BatchExtendTransaction bet with(nolock) on be.Id = bet.BatchExtendId
	left join BatchTransaction bt with(nolock) on bet.BatchTransactionId = bt.Id
where be.[Status] = 3
and be.Id not in (
	select be.Id
	from 
	(
		-- get BatchExtend.Ids that should be excluded because not all BatchTransaction is Done yet
		select
			be.Id, 
			bt.Status,
			count(bt.Id) as BatchTransactionCount
		from BatchExtend be with(nolock) 
			left join BatchExtendTransaction bet with(nolock) on be.Id = bet.BatchExtendId
			left join BatchTransaction bt with(nolock) on bet.BatchTransactionId = bt.Id
		where be.[Status] = 3
		group by be.Id, 
			bt.Status
		having bt.Status <> 3
	) be
)


	END