CREATE PROCEDURE [dbo].[spGetClientReport]
	@startPage int,
    @endPage int,
	@startDate nvarchar(200),
    @endDate nvarchar(200)    
AS
     
BEGIN

select * from (select ROW_NUMBER() OVER (ORDER by VoucherNumber) AS RowNum, ClientName,OrderNumber,ProductName,MerchantName,VoucherNumber,TranType,TranLocalDateTime,Status,ShopName
,BusinessModelId,Mobile,Email
 from 
(
	
SELECT          Client.Name AS ClientName, [Order].OrderNumber, 
                            Product.ProductName, Merchant.Name as MerchantName,Voucher.VoucherNumber, [Transaction].TranLocalDateTime,Voucher.Status,Shop.Name AS ShopName,
                            CASE [Transaction].TranType WHEN 101 THEN 'Redemption' ELSE 'ReverseRedemption' END AS TranType,     
                            ClientQuotation.BusinessModelId, OrderBeneficiaryInfo.Mobile, OrderBeneficiaryInfo.Email
FROM              OrderBeneficiaryInfo RIGHT OUTER JOIN
                            Voucher ON OrderBeneficiaryInfo.Id = Voucher.BeneficiaryInfoId LEFT OUTER JOIN
                            [Transaction] INNER JOIN
                            Program ON [Transaction].ProgramCode = Program.IdentityCode INNER JOIN
                            Product ON [Transaction].ProductId = Product.Id INNER JOIN
                            Merchant ON [Transaction].MerchantId = Merchant.Id INNER JOIN
                            Shop ON [Transaction].ShopId = Shop.Id INNER JOIN
                            [Order] ON [Transaction].OrderId = [Order].Id INNER JOIN
                            ClientQuotation ON [Order].ClientQuotationId = ClientQuotation.Id INNER JOIN
                            Client ON ClientQuotation.ClientId = Client.Id ON Voucher.VoucherNumber = [Transaction].AccountNumber AND 
                            Voucher.ProgramId = Program.Id
WHERE          ([Transaction].TranType IN (101, 201)) AND BusinessModelId<>9

	)as FF1
	
) FF
where FF.RowNum between @startPage and @endPage ORDER BY  VoucherNumber,ClientName
END