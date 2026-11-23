-- =============================================
-- Author:		Bruce CHEN
-- Create date: 2016/7/14
-- Description:	spGetTrustReimbursementProdStatistic
-- =============================================
CREATE PROCEDURE [dbo].[spGetTrustReimbursementProdStatistic]
	-- Add the parameters for the stored procedure here
	 @FromDate	int
	,@ToDate	int
	,@Brand varchar(50)  = NULL
	,@BusinessModelId int = NULL
	,@PageStart int 
	,@PageSize int 
	,@SumQty int output
	,@SumTotal decimal(20,6) output
	,@TotalCount int out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select * from (
	select p.ProductCode,
	       p.ProductName,
		   m.Name as MerchantName,
		   isnull(olta.TrustAccountBatchNo,'') as BatchNo,
	       abs(t.ReimbursementValue) as ReimbursementValue,
	       sum(case when t.TranType=101 then 1 else -1 end) as Qty,
	       sum(isnull(t.ReimbursementValue,0)) as Total,
	       row_number() over(order by p.ProductName) as rownumber
    from Voucher v 
		join [Transaction] t on v.VoucherNumber = t.AccountNumber 
		join OrderBeneficiaryInfo as o on v.BeneficiaryInfoId = o.Id
		join EXT_TW_OrderLineTrustAccount olta on o.OrderLineId = olta.id 
		join program pg on v.ProgramId = pg.id and t.ProgramCode = pg.IdentityCode
		join Product p on p.Id=t.ProductId  
		join ClientQuotationProduct c on c.Id=t.ClientQuotationProductId
		join ClientQuotation cq on cq.Id=c.ClientQuotationId
		join BusinessModel b on b.Id=cq.BusinessModelId
		join Dictionary d on d.Id=b.DisplayNameId
		join ProductExternalProperty pe on pe.id=p.ExternalPropertyId
		join ProductExternalPropertySet ps on ps.ProductExternalPropertyId=pe.Id		
		left join Shop s on s.Id=t.ShopId
		left join Merchant m on m.Id=t.MerchantId
		where (t.TranType = 101 or t.TranType = 201) 
		 and t.SettleDate >=@FromDate
		 and t.SettleDate <=@ToDate
		 and (isnull(@Brand,'')='' or p.ProductCode like ''+@Brand+'%')
		 and t.ResponseCode='0000'
		 and d.Name<>'Test'
		 and (ps.PropertyName='Brand' and ps.PropertyValue='wowprime')
		 and b.Id = 5
		 group by p.ProductCode,p.ProductName,m.Name,abs(t.ReimbursementValue),olta.TrustAccountBatchNo
	 ) A where rownumber>@pageStart 
	     and rownumber<=@pageStart + @pageSize

      select @TotalCount=count(1),
             @sumQty=sum(A.Qty),
	         @sumTotal=sum(A.Total) 
	   from (
		select p.ProductCode,
	           p.ProductName,
		       m.Name as MerchantName,
			   isnull(olta.TrustAccountBatchNo,'') as BatchNo,
	           abs(t.ReimbursementValue) as ReimbursementValue,
	           sum(case when t.TranType=101 then 1 else -1 end) as Qty,
	           sum(isnull(t.ReimbursementValue,0)) as Total,
	           row_number() over(order by p.ProductName) as rownumber
       from Voucher v 
	    join [Transaction] t on v.VoucherNumber = t.AccountNumber
		join OrderBeneficiaryInfo as o on v.BeneficiaryInfoId = o.Id
		join EXT_TW_OrderLineTrustAccount olta on o.OrderLineId = olta.id   
		join program pg on v.ProgramId = pg.id and t.ProgramCode = pg.IdentityCode
		join Product p on p.Id=t.ProductId  
		join ClientQuotationProduct c on c.Id=t.ClientQuotationProductId
		join ClientQuotation cq on cq.Id=c.ClientQuotationId
		join BusinessModel b on b.Id=cq.BusinessModelId
		join Dictionary d on d.Id=b.DisplayNameId
		join ProductExternalProperty pe on pe.id=p.ExternalPropertyId
		join ProductExternalPropertySet ps on ps.ProductExternalPropertyId=pe.Id		
		left join Shop s on s.Id=t.ShopId
		left join Merchant m on m.Id=t.MerchantId
		where (t.TranType = 101 or t.TranType = 201) 
		 and t.SettleDate >=@FromDate
		 and t.SettleDate <=@ToDate
		 and (isnull(@Brand,'')='' or p.ProductCode like ''+@Brand+'%')
		 and t.ResponseCode='0000'
		 and d.Name<>'Test'
		 and (ps.PropertyName='Brand' and ps.PropertyValue='wowprime')
		 and b.Id = 5
		 group by p.ProductCode,p.ProductName,m.Name,abs(t.ReimbursementValue),olta.TrustAccountBatchNo
		 ) A

END
