-- =============================================
-- Author:		Bruce CHEN
-- Create date: 2016/7/14
-- Description:	spQueryRedemptionReport
-- =============================================
CREATE PROCEDURE [dbo].[spGetRedemptionReport]
	-- Add the parameters for the stored procedure here
     @FromDate	int
	,@ToDate	int
	,@Brand     varchar(50)  = NULL
	,@PageStart int 
	,@PageSize int 
	,@TotalCount int out
	,@IsSelfUsage bit
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
		 row_number() over(order by t.Id) as rownumber
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
		left join Shop s on s.Id=t.ShopId
		left join Merchant m on m.Id=t.MerchantId
		where (t.TranType = 101 or t.TranType = 201) 
		 and t.SettleDate >=@FromDate
		 and t.SettleDate <=@ToDate
		 and (isnull(@Brand,'')='' or p.ProductCode like ''+@Brand+'%')
		 and t.ResponseCode='0000'
		 and d.Name<>'Test'
		 and (ps.PropertyName='Brand' and ps.PropertyValue='wowprime')
		 and ((@IsSelfUsage = 1 and b.id= 5 and olta.TrustAccountBatchNo is null) or (@IsSelfUsage=0 and ((b.id<> 5))))
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
		left join Shop s on s.Id=t.ShopId
		left join Merchant m on m.Id=t.MerchantId
		where (t.TranType = 101 or t.TranType = 201) 
		 and t.SettleDate >=@FromDate
		 and t.SettleDate <=@ToDate
		 and (isnull(@Brand,'')='' or p.ProductCode like ''+@Brand+'%')
		 and t.ResponseCode='0000'
		 and d.Name<>'Test'
		 and (ps.PropertyName='Brand' and ps.PropertyValue='wowprime')
		 and ((@IsSelfUsage = 1 and b.id= 5 and olta.TrustAccountBatchNo is null) or (@IsSelfUsage=0 and ((b.id<> 5))))

END

