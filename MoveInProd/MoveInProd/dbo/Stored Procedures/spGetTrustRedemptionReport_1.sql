-- =============================================
-- Author:		Zhu Jianhua
-- Create date: 2017/7/21
-- Description:	spGetWPTurstIssueReport
-- =============================================
CREATE PROCEDURE [dbo].[spGetTrustRedemptionReport]
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
		select t.Id,
		 t.ReimbursementValue,
		 s.Name as ConsumeShop,
		 v.PublishedOn,
		 m.Name as MerchantName,
		 t.TranType,
		 p.ProductName,
		 case when t.TranType = 201 then -1*t.TranAmount
			else t.TranAmount end as TranAmount,
		 t.ResponseCode,
		 t.SettleDate,
		 t.TranCode,
		 t.TranLocalDateTime,
		 t.AccountNumber,
		 s.IdentityCode as ShopIdentityCode,
		 T5.TrustAccountBatchNo AS BatchNo,
		 row_number() over(order by t.Id) as rownumber
		from Voucher v 
		join [Transaction] t on v.VoucherNumber = t.AccountNumber 
		join program pg on v.ProgramId = pg.id and t.ProgramCode = pg.IdentityCode
		join OrderBeneficiaryInfo as T4 ON V.BeneficiaryInfoId = T4.Id
		join EXT_TW_OrderLineTrustAccount as t5 ON T4.OrderLineId = T5.Id
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
	 ) A
	  where rownumber>@PageStart
	     and rownumber<=@PageStart + @PageSize
		--if(@Redemption is not null)
		

		select @TotalCount = count(1)
		from Voucher v 
		join [Transaction] t on v.VoucherNumber = t.AccountNumber  
		join program pg on v.ProgramId = pg.id and t.ProgramCode = pg.IdentityCode
		join OrderBeneficiaryInfo as T4 ON V.BeneficiaryInfoId = T4.Id
		join EXT_TW_OrderLineTrustAccount as t5 ON T4.OrderLineId = T5.Id
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
		 and b.Id = 5-- 5 should be Prepaid-for-Merchant-self

END

