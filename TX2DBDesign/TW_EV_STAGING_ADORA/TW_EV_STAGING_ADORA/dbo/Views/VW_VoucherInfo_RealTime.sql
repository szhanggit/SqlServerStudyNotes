CREATE VIEW dbo.VW_VoucherInfo_RealTime
AS
SELECT          mo_Product.ProductCode AS 'product_code', Account.AccountNumber AS 'voucher_no', 
                            Account.ActiveTo AS 'expired_date', (CASE mo_Product.ProductType WHEN 1 THEN
                                (SELECT          cast(round(cast(mo_ProductPricingProductBased.FaceValue AS INT) * 0.0105, 0) AS INT)
                                  FROM               u_ev_mo.dbo.ProductPricingProductBased mo_ProductPricingProductBased
                                  WHERE           mo_ProductVersion.ProductPricingProductBasedId = mo_ProductPricingProductBased.Id) 
                            ELSE
                                (SELECT          cast(round(cast(mo_ProductPricingValueBased.FaceValue AS INT) * 0.0105, 0) AS INT)
                                  FROM               u_ev_mo.dbo.ProductPricingValueBased mo_ProductPricingValueBased
                                  WHERE           mo_ProductVersion.ProductPricingValueBasedId = mo_ProductPricingValueBased.Id) END) 
                            AS 'product_face_value', Account.Status, Merchant.IdentityCode AS MerchantCode, 
                            Program.IdentityCode AS ProgramCode, (CASE WHEN [Transaction].TranType IS NOT NULL 
                            THEN [Transaction].TranType ELSE [TransactionHistory].TranType END) AS action_type, 
                            (CASE WHEN [Transaction].TranType IS NOT NULL 
                            THEN [Transaction].ResponseCode ELSE [TransactionHistory].ResponseCode END) AS result_type, 
                            (CASE WHEN [Transaction].TranLocalDateTime IS NOT NULL 
                            THEN [Transaction].TranLocalDateTime ELSE [TransactionHistory].TranLocalDateTime END) AS action_date, 
                            mo_ConsumeConfirmationInfo.ConfirmationInfo, mo_Voucher.Id as voucher_id
FROM              dbo.Merchant INNER JOIN
                            dbo.AcceptanceLoopMerchant ON dbo.Merchant.Id = dbo.AcceptanceLoopMerchant.MerchantId INNER JOIN
                            dbo.AcceptanceLoop ON dbo.AcceptanceLoopMerchant.AcceptanceLoopId = dbo.AcceptanceLoop.Id INNER JOIN
                            dbo. Product ON dbo.AcceptanceLoop.ProductId = dbo. Product .Id INNER JOIN
                            dbo.Program ON dbo. Product .ProgramId = dbo.Program.Id INNER JOIN
                            dbo.Account ON dbo. Product .Id = dbo.Account.ProductId AND 
                            dbo.Program.Id = dbo.Account.ProgramId LEFT OUTER JOIN
                            dbo.TransactionHistory ON dbo.Account.AccountNumber = dbo.TransactionHistory.AccountNumber AND 
                            dbo.Program.IdentityCode = dbo.TransactionHistory.ProgramCode LEFT OUTER JOIN
                            dbo.[Transaction] ON dbo.Account.AccountNumber = dbo.[Transaction].AccountNumber AND 
                            dbo.Program.IdentityCode = dbo.[Transaction].ProgramCode INNER JOIN
                            u_ev_mo.dbo. Product mo_Product ON Product .ExternalId = mo_Product.Id INNER JOIN
                            u_ev_mo.dbo.Voucher mo_Voucher ON mo_Product.Id = mo_Voucher.ProductId AND 
                            mo_Product.ProgramId = mo_Voucher.ProgramId AND 
                            Account.AccountNumber = mo_Voucher.VoucherNumber INNER JOIN
                            u_ev_mo.dbo.OrderBeneficiaryInfo mo_OrderBeneficiaryInfo ON 
                            mo_Voucher.BeneficiaryInfoId = mo_OrderBeneficiaryInfo.Id INNER JOIN
                            u_ev_mo.dbo.ProductVersion mo_ProductVersion ON 
                            mo_OrderBeneficiaryInfo.ProductVersionId = mo_ProductVersion.Id LEFT JOIN
                            u_ev_mo.dbo.ConsumeConfirmationInfo mo_ConsumeConfirmationInfo ON 
                            mo_Voucher.Id = mo_ConsumeConfirmationInfo.VoucherId
UNION ALL
SELECT          mo_Product.ProductCode AS 'product_code', AccountHistory.AccountNumber AS 'voucher_no', 
                            AccountHistory.ActiveTo AS 'expired_date', (CASE mo_Product.ProductType WHEN 1 THEN
                                (SELECT          cast(round(cast(mo_ProductPricingProductBased.FaceValue AS INT) * 0.0105, 0) AS INT)
                                  FROM               u_ev_mo.dbo.ProductPricingProductBased mo_ProductPricingProductBased
                                  WHERE           mo_ProductVersion.ProductPricingProductBasedId = mo_ProductPricingProductBased.Id) 
                            ELSE
                                (SELECT          cast(round(cast(mo_ProductPricingValueBased.FaceValue AS INT) * 0.0105, 0) AS INT)
                                  FROM               u_ev_mo.dbo.ProductPricingValueBased mo_ProductPricingValueBased
                                  WHERE           mo_ProductVersion.ProductPricingValueBasedId = mo_ProductPricingValueBased.Id) END) 
                            AS 'product_face_value', AccountHistory.Status, Merchant.IdentityCode AS MerchantCode, 
                            Program.IdentityCode AS ProgramCode, (CASE WHEN [Transaction].TranType IS NOT NULL 
                            THEN [Transaction].TranType ELSE [TransactionHistory].TranType END) AS action_type, 
                            (CASE WHEN [Transaction].TranType IS NOT NULL 
                            THEN [Transaction].ResponseCode ELSE [TransactionHistory].ResponseCode END) AS result_type, 
                            (CASE WHEN [Transaction].TranLocalDateTime IS NOT NULL 
                            THEN [Transaction].TranLocalDateTime ELSE [TransactionHistory].TranLocalDateTime END) AS action_date, 
                            mo_ConsumeConfirmationInfo.ConfirmationInfo, mo_Voucher.Id as voucher_id
FROM              dbo.Merchant INNER JOIN
                            dbo.AcceptanceLoopMerchant ON dbo.Merchant.Id = dbo.AcceptanceLoopMerchant.MerchantId INNER JOIN
                            dbo.AcceptanceLoop ON dbo.AcceptanceLoopMerchant.AcceptanceLoopId = dbo.AcceptanceLoop.Id INNER JOIN
                            dbo. Product ON dbo.AcceptanceLoop.ProductId = dbo. Product .Id INNER JOIN
                            dbo.Program ON dbo. Product .ProgramId = dbo.Program.Id INNER JOIN
                            dbo.AccountHistory ON dbo. Product .Id = dbo.AccountHistory.ProductId AND 
                            dbo.Program.Id = dbo.AccountHistory.ProgramId LEFT OUTER JOIN
                            dbo.TransactionHistory ON dbo.AccountHistory.AccountNumber = dbo.TransactionHistory.AccountNumber AND 
                            dbo.Program.IdentityCode = dbo.TransactionHistory.ProgramCode LEFT OUTER JOIN
                            dbo.[Transaction] ON dbo.AccountHistory.AccountNumber = dbo.[Transaction].AccountNumber AND 
                            dbo.Program.IdentityCode = dbo.[Transaction].ProgramCode INNER JOIN
                            u_ev_mo.dbo. Product mo_Product ON Product .ExternalId = mo_Product.Id INNER JOIN
                            u_ev_mo.dbo.Voucher mo_Voucher ON mo_Product.Id = mo_Voucher.ProductId AND 
                            mo_Product.ProgramId = mo_Voucher.ProgramId AND 
                            AccountHistory.AccountNumber = mo_Voucher.VoucherNumber INNER JOIN
                            u_ev_mo.dbo.OrderBeneficiaryInfo mo_OrderBeneficiaryInfo ON 
                            mo_Voucher.BeneficiaryInfoId = mo_OrderBeneficiaryInfo.Id INNER JOIN
                            u_ev_mo.dbo.ProductVersion mo_ProductVersion ON 
                            mo_OrderBeneficiaryInfo.ProductVersionId = mo_ProductVersion.Id LEFT JOIN
                            u_ev_mo.dbo.ConsumeConfirmationInfo mo_ConsumeConfirmationInfo ON 
                            mo_Voucher.Id = mo_ConsumeConfirmationInfo.VoucherId

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[36] 4[11] 2[37] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[22] 2[70] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2[69] 3) )"
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 3285
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_VoucherInfo_RealTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_VoucherInfo_RealTime';

