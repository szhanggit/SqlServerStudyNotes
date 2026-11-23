CREATE VIEW dbo.VW_RealTimeInfo
AS
SELECT          MO_Voucher.VoucherNumber AS Voucher_no, ADO_Transaction.TranType AS Trans_Type, 
                            ADO_Transaction.TranLocalDateTime AS Tran_Datetime,
                            ADO_Transaction.ResponseCode AS ResponseCode, 
                            ADO_Transaction.TranAmount AS TranAmount, 
                            ADO_Transaction.TerminalSSN AS TerminalSSN, 
                            ADO_Account.Status AS Status, MO_Shop.IdentityCode AS Shop_IdentityCode, MO_Shop.Name AS Shop_name, 
                            MO_Client.IdentityCode AS Client_IdentityCode, MO_Client.Name AS Client_name, 
                            MO_Merchant.IdentityCode AS Merchant_IdentityCode, MO_Merchant.Name AS Merchant_name, 
                            MO_Product.ProductCode AS Product_Code, MO_Product.ProductName AS Product_name, 
                            MO_OrderBeneficiaryInfo.ClientOrderNumber AS Order_No, CASE MO_Product.ProductType WHEN 1 THEN
                                (SELECT          u_ev_mo.dbo.F_GetReimbursementValueByProductID(MO_Voucher.ProductId)) 
                            ELSE
                                ((SELECT          isnull(ppvb.FaceValue, 0) / 100
                                    FROM              u_ev_mo.dbo.ProductPricingValueBased ppvb
                                    WHERE          ppvb.Id = MO_ProductVersion.ProductPricingValueBasedId) *
                                (SELECT          u_ev_mo.dbo.F_GetReimbursementValueByProductID(MO_Voucher.ProductId))) 
                            / 100 END AS Cost, CASE MO_Product.ProductType WHEN 1 THEN
                                (SELECT          cast(round(cast(MO_ProductPricingProductBased.FaceValue AS INT) / 100, 0) AS INT)
                                  FROM               u_ev_mo.dbo.ProductPricingProductBased MO_ProductPricingProductBased
                                  WHERE           MO_ProductVersion.ProductPricingProductBasedId = MO_ProductPricingProductBased.Id) 
                            ELSE
                                (SELECT          cast(round(cast(MO_ProductPricingValueBased.FaceValue AS INT) / 100, 0) AS INT)
                                  FROM               u_ev_mo.dbo.ProductPricingValueBased MO_ProductPricingValueBased
                                  WHERE           MO_ProductVersion.ProductPricingValueBasedId = MO_ProductPricingValueBased.Id) 
                            END AS Face_Value
FROM              u_ev_authorization.dbo.Account AS ADO_Account LEFT JOIN
                            u_ev_authorization.dbo. Product AS ADO_Product ON ADO_Account.ProductId = ADO_Product.Id LEFT JOIN
                            u_ev_authorization.dbo.Program AS ADO_Program ON ADO_Account.ProgramId = ADO_Program.Id LEFT JOIN
                            u_ev_authorization.dbo.AcceptanceLoop AS ADO_AcceptanceLoop ON 
                            ADO_AcceptanceLoop.ProductId = ADO_Product.Id AND ADO_AcceptanceLoop.ProgramId = ADO_Program.Id LEFT JOIN
                            u_ev_authorization.dbo.AcceptanceLoopMerchant AS ADO_AcceptanceLoopMerchant ON 
                            ADO_AcceptanceLoop.Id = ADO_AcceptanceLoopMerchant.AcceptanceLoopId LEFT JOIN
                            u_ev_authorization.dbo.Merchant AS ADO_Merchant ON 
                            ADO_AcceptanceLoopMerchant.MerchantId = ADO_Merchant.Id LEFT JOIN
                            u_ev_authorization.dbo.[Transaction] AS ADO_Transaction ON 
                            ADO_Account.AccountNumber = ADO_Transaction.AccountNumber AND 
                            ADO_Program.IdentityCode = ADO_Transaction.ProgramCode LEFT JOIN
                            
                            u_ev_authorization.dbo.Shop AS ADO_Shop ON ADO_Transaction.ShopCode = ADO_Shop.IdentityCode LEFT JOIN
                            u_ev_mo.dbo. Product AS MO_Product ON ADO_Product.ExternalId = MO_Product.Id LEFT JOIN
                            u_ev_mo.dbo.Program AS MO_Program ON ADO_Program.ExternalId = MO_Program.Id LEFT JOIN
                            u_ev_mo.dbo.Voucher AS MO_Voucher ON 
                            ADO_Account.AccountNumber = MO_Voucher.VoucherNumber AND MO_Product.Id = MO_Voucher.ProductId AND 
                            MO_Program.Id = MO_Voucher.ProgramId LEFT JOIN
                            u_ev_mo.dbo.OrderBeneficiaryInfo AS MO_OrderBeneficiaryInfo ON 
                            MO_Voucher.BeneficiaryInfoId = MO_OrderBeneficiaryInfo.Id LEFT JOIN
                            u_ev_mo.dbo.OrderLine AS MO_OrderLine ON 
                            MO_OrderBeneficiaryInfo.OrderLineId = MO_OrderLine.Id LEFT JOIN
                            u_ev_mo.dbo.[Order] AS MO_Order ON MO_OrderLine.OrderId = MO_Order.Id LEFT JOIN
                            u_ev_mo.dbo.ProductVersion AS MO_ProductVersion ON 
                            MO_OrderBeneficiaryInfo.ProductVersionId = MO_ProductVersion.Id LEFT JOIN
                            u_ev_mo.dbo.ClientQuotation AS MO_ClientQuotation ON 
                            MO_Order.ClientQuotationId = MO_ClientQuotation.Id LEFT JOIN
                            u_ev_mo.dbo.Client AS MO_Client ON MO_ClientQuotation.ClientId = MO_Client.Id LEFT JOIN
                            u_ev_mo.dbo.Merchant AS MO_Merchant ON ADO_Merchant.ExternalId = MO_Merchant.Id LEFT JOIN
                            u_ev_mo.dbo.Shop AS MO_Shop ON ADO_Shop.ExternalId = MO_Shop.Id
UNION
SELECT          MO_Voucher.VoucherNumber AS Voucher_no, ADO_TransactionHistory.TranType AS Trans_Type, 
                           ADO_TransactionHistory.TranLocalDateTime AS Tran_Datetime,
                            ADO_TransactionHistory.ResponseCode AS ResponseCode, 
                            ADO_TransactionHistory.TranAmount AS TranAmount, 
                            ADO_TransactionHistory.TerminalSSN AS TerminalSSN, 
                            ADO_Account.Status AS Status, MO_Shop.IdentityCode AS Shop_IdentityCode, MO_Shop.Name AS Shop_name, 
                            MO_Client.IdentityCode AS Client_IdentityCode, MO_Client.Name AS Client_name, 
                            MO_Merchant.IdentityCode AS Merchant_IdentityCode, MO_Merchant.Name AS Merchant_name, 
                            MO_Product.ProductCode AS Product_Code, MO_Product.ProductName AS Product_name, 
                            MO_OrderBeneficiaryInfo.ClientOrderNumber AS Order_No, CASE MO_Product.ProductType WHEN 1 THEN
                                (SELECT          u_ev_mo.dbo.F_GetReimbursementValueByProductID(MO_Voucher.ProductId)) 
                            ELSE
                                ((SELECT          isnull(ppvb.FaceValue, 0) / 100
                                    FROM              u_ev_mo.dbo.ProductPricingValueBased ppvb
                                    WHERE          ppvb.Id = MO_ProductVersion.ProductPricingValueBasedId) *
                                (SELECT          u_ev_mo.dbo.F_GetReimbursementValueByProductID(MO_Voucher.ProductId))) 
                            / 100 END AS Cost, CASE MO_Product.ProductType WHEN 1 THEN
                                (SELECT          cast(round(cast(MO_ProductPricingProductBased.FaceValue AS INT) / 100, 0) AS INT)
                                  FROM               u_ev_mo.dbo.ProductPricingProductBased MO_ProductPricingProductBased
                                  WHERE           MO_ProductVersion.ProductPricingProductBasedId = MO_ProductPricingProductBased.Id) 
                            ELSE
                                (SELECT          cast(round(cast(MO_ProductPricingValueBased.FaceValue AS INT) / 100, 0) AS INT)
                                  FROM               u_ev_mo.dbo.ProductPricingValueBased MO_ProductPricingValueBased
                                  WHERE           MO_ProductVersion.ProductPricingValueBasedId = MO_ProductPricingValueBased.Id) 
                            END AS Face_Value
FROM              u_ev_authorization.dbo.Account AS ADO_Account LEFT JOIN
                            u_ev_authorization.dbo. Product AS ADO_Product ON ADO_Account.ProductId = ADO_Product.Id LEFT JOIN
                            u_ev_authorization.dbo.Program AS ADO_Program ON ADO_Account.ProgramId = ADO_Program.Id LEFT JOIN
                            u_ev_authorization.dbo.AcceptanceLoop AS ADO_AcceptanceLoop ON 
                            ADO_AcceptanceLoop.ProductId = ADO_Product.Id AND ADO_AcceptanceLoop.ProgramId = ADO_Program.Id LEFT JOIN
                            u_ev_authorization.dbo.AcceptanceLoopMerchant AS ADO_AcceptanceLoopMerchant ON 
                            ADO_AcceptanceLoop.Id = ADO_AcceptanceLoopMerchant.AcceptanceLoopId LEFT JOIN
                            u_ev_authorization.dbo.Merchant AS ADO_Merchant ON 
                            ADO_AcceptanceLoopMerchant.MerchantId = ADO_Merchant.Id LEFT JOIN
                            u_ev_authorization.dbo.[TransactionHistory] AS ADO_TransactionHistory ON 
                            ADO_Account.AccountNumber = ADO_TransactionHistory.AccountNumber AND 
                            ADO_Program.IdentityCode = ADO_TransactionHistory.ProgramCode LEFT JOIN
                            u_ev_authorization.dbo.Shop AS ADO_Shop ON ADO_TransactionHistory.ShopCode = ADO_Shop.IdentityCode LEFT JOIN
                            u_ev_mo.dbo. Product AS MO_Product ON ADO_Product.ExternalId = MO_Product.Id LEFT JOIN
                            u_ev_mo.dbo.Program AS MO_Program ON ADO_Program.ExternalId = MO_Program.Id LEFT JOIN
                            u_ev_mo.dbo.Voucher AS MO_Voucher ON 
                            ADO_Account.AccountNumber = MO_Voucher.VoucherNumber AND MO_Product.Id = MO_Voucher.ProductId AND 
                            MO_Program.Id = MO_Voucher.ProgramId LEFT JOIN
                            u_ev_mo.dbo.OrderBeneficiaryInfo AS MO_OrderBeneficiaryInfo ON 
                            MO_Voucher.BeneficiaryInfoId = MO_OrderBeneficiaryInfo.Id LEFT JOIN
                            u_ev_mo.dbo.OrderLine AS MO_OrderLine ON 
                            MO_OrderBeneficiaryInfo.OrderLineId = MO_OrderLine.Id LEFT JOIN
                            u_ev_mo.dbo.[Order] AS MO_Order ON MO_OrderLine.OrderId = MO_Order.Id LEFT JOIN
                            u_ev_mo.dbo.ProductVersion AS MO_ProductVersion ON 
                            MO_OrderBeneficiaryInfo.ProductVersionId = MO_ProductVersion.Id LEFT JOIN
                            u_ev_mo.dbo.ClientQuotation AS MO_ClientQuotation ON 
                            MO_Order.ClientQuotationId = MO_ClientQuotation.Id LEFT JOIN
                            u_ev_mo.dbo.Client AS MO_Client ON MO_ClientQuotation.ClientId = MO_Client.Id LEFT JOIN
                            u_ev_mo.dbo.Merchant AS MO_Merchant ON ADO_Merchant.ExternalId = MO_Merchant.Id LEFT JOIN
                            u_ev_mo.dbo.Shop AS MO_Shop ON ADO_Shop.ExternalId = MO_Shop.Id
UNION
SELECT          MO_Voucher.VoucherNumber AS Voucher_no, ADO_Transaction.TranType AS Trans_Type, 
                            ADO_Transaction.TranLocalDateTime AS Tran_Datetime,
                            ADO_Transaction.ResponseCode AS ResponseCode, 
                            ADO_Transaction.TranAmount AS TranAmount, 
                            ADO_Transaction.TerminalSSN AS TerminalSSN, 
                            ADO_AccountHistory.Status AS Status, MO_Shop.IdentityCode AS Shop_IdentityCode, 
                            MO_Shop.Name AS Shop_name, MO_Client.IdentityCode AS Client_IdentityCode, MO_Client.Name AS Client_name, 
                            MO_Merchant.IdentityCode AS Merchant_IdentityCode, MO_Merchant.Name AS Merchant_name, 
                            MO_Product.ProductCode AS Product_Code, MO_Product.ProductName AS Product_name, 
                            MO_OrderBeneficiaryInfo.ClientOrderNumber AS Order_No, CASE MO_Product.ProductType WHEN 1 THEN
                                (SELECT          u_ev_mo.dbo.F_GetReimbursementValueByProductID(MO_Voucher.ProductId)) 
                            ELSE
                                ((SELECT          isnull(ppvb.FaceValue, 0) / 100
                                    FROM              u_ev_mo.dbo.ProductPricingValueBased ppvb
                                    WHERE          ppvb.Id = MO_ProductVersion.ProductPricingValueBasedId) *
                                (SELECT          u_ev_mo.dbo.F_GetReimbursementValueByProductID(MO_Voucher.ProductId))) 
                            / 100 END AS Cost, CASE MO_Product.ProductType WHEN 1 THEN
                                (SELECT          cast(round(cast(MO_ProductPricingProductBased.FaceValue AS INT) / 100, 0) AS INT)
                                  FROM               u_ev_mo.dbo.ProductPricingProductBased MO_ProductPricingProductBased
                                  WHERE           MO_ProductVersion.ProductPricingProductBasedId = MO_ProductPricingProductBased.Id) 
                            ELSE
                                (SELECT          cast(round(cast(MO_ProductPricingValueBased.FaceValue AS INT) / 100, 0) AS INT)
                                  FROM               u_ev_mo.dbo.ProductPricingValueBased MO_ProductPricingValueBased
                                  WHERE           MO_ProductVersion.ProductPricingValueBasedId = MO_ProductPricingValueBased.Id) 
                            END AS Face_Value
FROM              u_ev_authorization.dbo.AccountHistory AS ADO_AccountHistory LEFT JOIN
                            u_ev_authorization.dbo. Product AS ADO_Product ON ADO_AccountHistory.ProductId = ADO_Product.Id LEFT JOIN
                            u_ev_authorization.dbo.Program AS ADO_Program ON ADO_AccountHistory.ProgramId = ADO_Program.Id LEFT 
                            JOIN
                            u_ev_authorization.dbo.AcceptanceLoop AS ADO_AcceptanceLoop ON 
                            ADO_AcceptanceLoop.ProductId = ADO_Product.Id AND ADO_AcceptanceLoop.ProgramId = ADO_Program.Id LEFT JOIN
                            u_ev_authorization.dbo.AcceptanceLoopMerchant AS ADO_AcceptanceLoopMerchant ON 
                            ADO_AcceptanceLoop.Id = ADO_AcceptanceLoopMerchant.AcceptanceLoopId LEFT JOIN
                            u_ev_authorization.dbo.Merchant AS ADO_Merchant ON 
                            ADO_AcceptanceLoopMerchant.MerchantId = ADO_Merchant.Id LEFT JOIN
                            u_ev_authorization.dbo.[Transaction] AS ADO_Transaction ON 
                            ADO_AccountHistory.AccountNumber = ADO_Transaction.AccountNumber AND 
                            ADO_Program.IdentityCode = ADO_Transaction.ProgramCode LEFT JOIN
                            u_ev_authorization.dbo.Shop AS ADO_Shop ON ADO_Transaction.ShopCode = ADO_Shop.IdentityCode LEFT JOIN
                            u_ev_mo.dbo. Product AS MO_Product ON ADO_Product.ExternalId = MO_Product.Id LEFT JOIN
                            u_ev_mo.dbo.Program AS MO_Program ON ADO_Program.ExternalId = MO_Program.Id LEFT JOIN
                            u_ev_mo.dbo.Voucher AS MO_Voucher ON 
                            ADO_AccountHistory.AccountNumber = MO_Voucher.VoucherNumber AND MO_Product.Id = MO_Voucher.ProductId AND
                             MO_Program.Id = MO_Voucher.ProgramId LEFT JOIN
                            u_ev_mo.dbo.OrderBeneficiaryInfo AS MO_OrderBeneficiaryInfo ON 
                            MO_Voucher.BeneficiaryInfoId = MO_OrderBeneficiaryInfo.Id LEFT JOIN
                            u_ev_mo.dbo.OrderLine AS MO_OrderLine ON 
                            MO_OrderBeneficiaryInfo.OrderLineId = MO_OrderLine.Id LEFT JOIN
                            u_ev_mo.dbo.[Order] AS MO_Order ON MO_OrderLine.OrderId = MO_Order.Id LEFT JOIN
                            u_ev_mo.dbo.ProductVersion AS MO_ProductVersion ON 
                            MO_OrderBeneficiaryInfo.ProductVersionId = MO_ProductVersion.Id LEFT JOIN
                            u_ev_mo.dbo.ClientQuotation AS MO_ClientQuotation ON 
                            MO_Order.ClientQuotationId = MO_ClientQuotation.Id LEFT JOIN
                            u_ev_mo.dbo.Client AS MO_Client ON MO_ClientQuotation.ClientId = MO_Client.Id LEFT JOIN
                            u_ev_mo.dbo.Merchant AS MO_Merchant ON ADO_Merchant.ExternalId = MO_Merchant.Id LEFT JOIN
                            u_ev_mo.dbo.Shop AS MO_Shop ON ADO_Shop.ExternalId = MO_Shop.Id
UNION
SELECT          MO_Voucher.VoucherNumber AS Voucher_no, ADO_TransactionHistory.TranType AS Trans_Type, 
                            ADO_TransactionHistory.TranLocalDateTime AS Tran_Datetime,
                            ADO_TransactionHistory.ResponseCode AS ResponseCode, 
                            ADO_TransactionHistory.TranAmount AS TranAmount, 
                            ADO_TransactionHistory.TerminalSSN AS TerminalSSN, 
                            ADO_AccountHistory.Status AS Status, MO_Shop.IdentityCode AS Shop_IdentityCode, 
                            MO_Shop.Name AS Shop_name, MO_Client.IdentityCode AS Client_IdentityCode, MO_Client.Name AS Client_name, 
                            MO_Merchant.IdentityCode AS Merchant_IdentityCode, MO_Merchant.Name AS Merchant_name, 
                            MO_Product.ProductCode AS Product_Code, MO_Product.ProductName AS Product_name, 
                            MO_OrderBeneficiaryInfo.ClientOrderNumber AS Order_No, CASE MO_Product.ProductType WHEN 1 THEN
                                (SELECT          u_ev_mo.dbo.F_GetReimbursementValueByProductID(MO_Voucher.ProductId)) 
                            ELSE
                                ((SELECT          isnull(ppvb.FaceValue, 0) / 100
                                    FROM              u_ev_mo.dbo.ProductPricingValueBased ppvb
                                    WHERE          ppvb.Id = MO_ProductVersion.ProductPricingValueBasedId) *
                                (SELECT          u_ev_mo.dbo.F_GetReimbursementValueByProductID(MO_Voucher.ProductId))) 
                            / 100 END AS Cost, CASE MO_Product.ProductType WHEN 1 THEN
                                (SELECT          cast(round(cast(MO_ProductPricingProductBased.FaceValue AS INT) / 100, 0) AS INT)
                                  FROM               u_ev_mo.dbo.ProductPricingProductBased MO_ProductPricingProductBased
                                  WHERE           MO_ProductVersion.ProductPricingProductBasedId = MO_ProductPricingProductBased.Id) 
                            ELSE
                                (SELECT          cast(round(cast(MO_ProductPricingValueBased.FaceValue AS INT) / 100, 0) AS INT)
                                  FROM               u_ev_mo.dbo.ProductPricingValueBased MO_ProductPricingValueBased
                                  WHERE           MO_ProductVersion.ProductPricingValueBasedId = MO_ProductPricingValueBased.Id) 
                            END AS Face_Value
FROM              u_ev_authorization.dbo.AccountHistory AS ADO_AccountHistory LEFT JOIN
                            u_ev_authorization.dbo. Product AS ADO_Product ON ADO_AccountHistory.ProductId = ADO_Product.Id LEFT JOIN
                            u_ev_authorization.dbo.Program AS ADO_Program ON ADO_AccountHistory.ProgramId = ADO_Program.Id LEFT 
                            JOIN
                            u_ev_authorization.dbo.AcceptanceLoop AS ADO_AcceptanceLoop ON 
                            ADO_AcceptanceLoop.ProductId = ADO_Product.Id AND ADO_AcceptanceLoop.ProgramId = ADO_Program.Id LEFT JOIN
                            u_ev_authorization.dbo.AcceptanceLoopMerchant AS ADO_AcceptanceLoopMerchant ON 
                            ADO_AcceptanceLoop.Id = ADO_AcceptanceLoopMerchant.AcceptanceLoopId LEFT JOIN
                            u_ev_authorization.dbo.Merchant AS ADO_Merchant ON 
                            ADO_AcceptanceLoopMerchant.MerchantId = ADO_Merchant.Id LEFT JOIN
                            u_ev_authorization.dbo.[TransactionHistory] AS ADO_TransactionHistory ON 
                            ADO_AccountHistory.AccountNumber = ADO_TransactionHistory.AccountNumber AND 
                            ADO_Program.IdentityCode = ADO_TransactionHistory.ProgramCode LEFT JOIN
                            u_ev_authorization.dbo.Shop AS ADO_Shop ON ADO_TransactionHistory.ShopCode = ADO_Shop.IdentityCode LEFT JOIN
                            u_ev_mo.dbo. Product AS MO_Product ON ADO_Product.ExternalId = MO_Product.Id LEFT JOIN
                            u_ev_mo.dbo.Program AS MO_Program ON ADO_Program.ExternalId = MO_Program.Id LEFT JOIN
                            u_ev_mo.dbo.Voucher AS MO_Voucher ON 
                            ADO_AccountHistory.AccountNumber = MO_Voucher.VoucherNumber AND MO_Product.Id = MO_Voucher.ProductId AND
                             MO_Program.Id = MO_Voucher.ProgramId LEFT JOIN
                            u_ev_mo.dbo.OrderBeneficiaryInfo AS MO_OrderBeneficiaryInfo ON 
                            MO_Voucher.BeneficiaryInfoId = MO_OrderBeneficiaryInfo.Id LEFT JOIN
                            u_ev_mo.dbo.OrderLine AS MO_OrderLine ON 
                            MO_OrderBeneficiaryInfo.OrderLineId = MO_OrderLine.Id LEFT JOIN
                            u_ev_mo.dbo.[Order] AS MO_Order ON MO_OrderLine.OrderId = MO_Order.Id LEFT JOIN
                            u_ev_mo.dbo.ProductVersion AS MO_ProductVersion ON 
                            MO_OrderBeneficiaryInfo.ProductVersionId = MO_ProductVersion.Id LEFT JOIN
                            u_ev_mo.dbo.ClientQuotation AS MO_ClientQuotation ON 
                            MO_Order.ClientQuotationId = MO_ClientQuotation.Id LEFT JOIN
                            u_ev_mo.dbo.Client AS MO_Client ON MO_ClientQuotation.ClientId = MO_Client.Id LEFT JOIN
                            u_ev_mo.dbo.Merchant AS MO_Merchant ON ADO_Merchant.ExternalId = MO_Merchant.Id LEFT JOIN
                            u_ev_mo.dbo.Shop AS MO_Shop ON ADO_Shop.ExternalId = MO_Shop.Id

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[13] 4[48] 2[21] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2[66] 3) )"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 5
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_RealTimeInfo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_RealTimeInfo';

