-- =============================================
-- Author:		Zhu Jianhua
-- Create date: 2017/7/21
-- Description:	pGetWPIssueReport
-- =============================================
CREATE PROCEDURE [dbo].[spGetWPIssueReport]
	-- Add the parameters for the stored procedure here
     @FromDate	int
	,@ToDate	int
	,@Brand     varchar(50)  = NULL
	,@BusinessModelId int = NULL
	,@PageStart int 
	,@PageSize int 
	,@TotalCount int out
AS
BEGIN
	select * from 
	(
		select T7.Name AS ClientName,
		 p.ProductCode,
		 p.ProductName,
		 v.ActivatedOn AS ActiveDate,
		 COUNT(1) AS IssueQuantity,
		 row_number() over(order by p.Id) as rownumber
		from Voucher v 
		join [Transaction] t on v.VoucherNumber = t.AccountNumber
		join OrderBeneficiaryInfo as o on v.BeneficiaryInfoId = o.Id
		left join EXT_TW_OrderLineTrustAccount olta on o.OrderLineId = olta.id 
		join program pg on v.ProgramId = pg.id and t.ProgramCode = pg.IdentityCode
		join Product p on p.Id=t.ProductId  
		join ClientQuotationProduct c on c.Id=t.ClientQuotationProductId
		join ClientQuotation cq on cq.Id=c.ClientQuotationId
		join Client AS T7 ON cq.ClientId = T7.Id
		join BusinessModel b on b.Id=cq.BusinessModelId
		join Dictionary d on d.Id=b.DisplayNameId
		join ProductExternalProperty pe on pe.id=p.ExternalPropertyId
		join ProductExternalPropertySet ps on ps.ProductExternalPropertyId=pe.Id
		where t.ResponseCode='0000'
		 and t.SettleDate >=@FromDate
		 and t.SettleDate <=@ToDate
		 and (isnull(@Brand,'')='' or p.ProductCode like ''+@Brand+'%')
		 and d.Name<>'Test'
		 and (ps.PropertyName='Brand' and ps.PropertyValue='wowprime')
		 and (b.Id = 5 and olta.TrustAccountBatchNo is null)		 
		 GROUP BY T7.Name,p.ProductCode,p.ProductName,v.ActivatedOn,p.Id
	 ) A
	  where rownumber>@PageStart
	     and rownumber<=@PageStart + @PageSize
		--if(@Redemption is not null)
		

		select @TotalCount = count(1)
		from Voucher v 
		join [Transaction] t on v.VoucherNumber = t.AccountNumber
		join OrderBeneficiaryInfo as o on v.BeneficiaryInfoId = o.Id
		left join EXT_TW_OrderLineTrustAccount olta on o.OrderLineId = olta.id 
		join program pg on v.ProgramId = pg.id and t.ProgramCode = pg.IdentityCode
		join Product p on p.Id=t.ProductId  
		join ClientQuotationProduct c on c.Id=t.ClientQuotationProductId
		join ClientQuotation cq on cq.Id=c.ClientQuotationId
		join BusinessModel b on b.Id=cq.BusinessModelId
		join Dictionary d on d.Id=b.DisplayNameId
		join ProductExternalProperty pe on pe.id=p.ExternalPropertyId
		join ProductExternalPropertySet ps on ps.ProductExternalPropertyId=pe.Id
		where t.ResponseCode='0000' 
		 and t.SettleDate >=@FromDate
		 and t.SettleDate <=@ToDate
		 and (isnull(@Brand,'')='' or p.ProductCode like ''+@Brand+'%')
		 and d.Name<>'Test'
		 and (ps.PropertyName='Brand' and ps.PropertyValue='wowprime')
		 and (b.Id = 5 and olta.TrustAccountBatchNo is null)

END

