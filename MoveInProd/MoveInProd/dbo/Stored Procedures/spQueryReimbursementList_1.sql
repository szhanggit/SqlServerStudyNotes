-- =============================================
-- Author:		Bruce CHEN
-- Create date: 2016/7/14
-- Description:	spQueryReimbursementList
-- =============================================
CREATE PROCEDURE [dbo].[spQueryReimbursementList]
	-- Add the parameters for the stored procedure here
    
	 @PageStart int 
	,@PageSize int 
	,@ReimbursementId bigint
	,@TotalCount int output
	
AS
BEGIN
	SELECT * FROM 
	(				select C.Name as Client
					,V.PublishedOn as DeliveryDateTime
					,M.Name as Merchant
					,T.TranType as ProcessType
					,P.ProductName as Product
					,P.ProductType as ProductType
					,T.TranAmount as Quantity
					,t.ResponseCode as ResultType
					,S.Name as Shop
					,t.ShopId
					, t.TranCode as TranCode
					,t.TranLocalDateTime as TransactionDate
					,t.AccountNumber as VoucherNumber
					,t.SettleDate as SettleDate
					,CASE WHEN p.ProductType = 1
						THEN 0
						ELSE --t.TranAmount*1.0000/105
							CASE WHEN t.TranType = 201 
								THEN -t.TranAmount*1.0000/105
							ELSE t.TranAmount*1.0000/105
						END
					END AS TransactionAmount
					,t.ReimbursementValue as ReimbursementAmount
					,CQ.BusinessModelId as BusinessModel
					,t.Rsv1 as Rsv1
					, P.ProductCode AS ProductCode
					, P.ExternalProductCode AS ExternalProductCode
					, T.TerminalSSN AS TerminalSSN
					,row_number() over(order by T.id) as rownumber
					from  [dbo].[Transaction] T WITH (NOLOCK)
					join [ReimbursementLine] RL WITH (NOLOCK) on T.ReimbursementLineId=RL.id
					join [Voucher] V WITH (NOLOCK) on T.AccountNumber=V.VoucherNumber
					join [Order] O WITH (NOLOCK) on T.OrderId=O.Id
					join ClientQuotation  CQ WITH (NOLOCK) on CQ.Id=O.ClientQuotationId
					join Client C WITH (NOLOCK) on C.Id=CQ.ClientId
					join Merchant M WITH (NOLOCK) on M.Id=T.MerchantId
					join Product P WITH (NOLOCK) on P.Id=T.ProductId
					left join shop S WITH (NOLOCK) on T.ShopId=S.Id
					join Program PM WITH(NOLOCK) on T.ProgramCode = PM.IdentityCode AND V.ProgramId = PM.Id
					where RL.ReimbursementId=@ReimbursementId and T.ReimbursementValue<>0 and T.ResponseCode='0000'
	 ) A
		WHERE rownumber>@PageStart and rownumber<=@PageStart + @PageSize


		SELECT @TotalCount=count(1) FROM 
	(				select C.Name as Client
					,V.PublishedOn as DeliveryDateTime
					,M.Name as Merchant
					,T.TranType as ProcessType
					,P.ProductName as Product
					,P.ProductType as ProductType
					,T.TranAmount as Quantity
					,t.ResponseCode as ResultType
					,S.Name as Shop
					,t.ShopId
					, t.TranCode as TranCode
					,t.TranLocalDateTime as TransactionDate
					,t.AccountNumber as VoucherNumber
					,t.SettleDate as SettleDate
					,CASE WHEN p.ProductType = 1
						THEN 0
						ELSE --t.TranAmount*1.0000/105
							CASE WHEN t.TranType = 201
								 THEN -t.TranAmount*1.0000/105
							ELSE t.TranAmount*1.0000/105
						END
					END AS TransactionAmount
					,t.ReimbursementValue as ReimbursementAmount
					,CQ.BusinessModelId as BusinessModel
					,t.Rsv1 as Rsv1
					, P.ProductCode AS ProductCode
					, P.ExternalProductCode AS ExternalProductCode
					, T.TerminalSSN AS TerminalSSN
					,row_number() over(order by T.id) as rownumber
					from  [dbo].[Transaction] T WITH (NOLOCK)
					join [ReimbursementLine] RL WITH (NOLOCK) on T.ReimbursementLineId=RL.id
					join [Voucher] V WITH (NOLOCK) on T.AccountNumber=V.VoucherNumber
					join [Order] O WITH (NOLOCK) on T.OrderId=O.Id
					join ClientQuotation  CQ WITH (NOLOCK) on CQ.Id=O.ClientQuotationId
					join Client C WITH (NOLOCK) on C.Id=CQ.ClientId
					join Merchant M WITH (NOLOCK) on M.Id=T.MerchantId
					join Product P WITH (NOLOCK) on P.Id=T.ProductId
					left join shop S WITH (NOLOCK) on T.ShopId=S.Id
					join Program PM WITH(NOLOCK) on T.ProgramCode = PM.IdentityCode  AND V.ProgramId = PM.Id
					where RL.ReimbursementId=@ReimbursementId and T.ReimbursementValue<>0 and T.ResponseCode='0000'
	 ) A
		
END

