CREATE VIEW dbo.VW_VoucherInfo_RealTime
AS
SELECT          mo_Product.ExternalProductCode AS 'product_code', Account.AccountNumber AS 'voucher_no', DATEADD(HOUR, 8, 
                            Account.ActiveTo) AS 'expired_date', (CASE mo_Product.ProductType WHEN 1 THEN
                                (SELECT          cast(round(cast(mo_ProductPricingProductBased.FaceValue AS DECIMAL) * 0.0105, 0) AS INT)
                                  FROM               TW_EV_DBS_MOVE.dbo.ProductPricingProductBased mo_ProductPricingProductBased
                                  WHERE           mo_ProductVersion.ProductPricingProductBasedId = mo_ProductPricingProductBased.Id) 
                            ELSE
                                (SELECT          cast(round(cast(mo_ProductPricingValueBased.FaceValue AS DECIMAL) * 0.0105, 0) AS INT)
                                  FROM               TW_EV_DBS_MOVE.dbo.ProductPricingValueBased mo_ProductPricingValueBased
                                  WHERE           mo_ProductVersion.ProductPricingValueBasedId = mo_ProductPricingValueBased.Id) END) 
                            AS 'product_face_value', Account.Status, Merchant.IdentityCode AS MerchantCode, 
                            Program.IdentityCode AS ProgramCode, [Transaction].TranType AS action_type, 
                            [Transaction].ResponseCode AS result_type, [Transaction].TranLocalDateTime AS action_date, 
                            mo_ConsumeConfirmationInfo.ConfirmationInfo, mo_Voucher.Id AS voucher_id
FROM              dbo.Merchant WITH (NOLOCK)INNER JOIN
                            dbo.AcceptanceLoopMerchant WITH (NOLOCK) ON dbo.Merchant.Id = dbo.AcceptanceLoopMerchant.MerchantId INNER JOIN
                            dbo.AcceptanceLoop WITH (NOLOCK) ON dbo.AcceptanceLoopMerchant.AcceptanceLoopId = dbo.AcceptanceLoop.Id INNER JOIN
                            dbo. Product WITH (NOLOCK) ON dbo.AcceptanceLoop.ProductId = dbo. Product .Id INNER JOIN
                            dbo.Program WITH (NOLOCK) ON dbo. Product .ProgramId = dbo.Program.Id INNER JOIN
                            dbo.Account WITH (NOLOCK) ON dbo. Product .Id = dbo.Account.ProductId AND 
                            dbo.Program.Id = dbo.Account.ProgramId LEFT OUTER JOIN
                            dbo.[Transaction] WITH (NOLOCK) ON dbo.Account.AccountNumber = dbo.[Transaction].AccountNumber AND 
                            dbo.Program.IdentityCode = dbo.[Transaction].ProgramCode INNER JOIN
                            TW_EV_DBS_MOVE.dbo. Product mo_Product WITH (NOLOCK) ON Product .ExternalId = mo_Product.Id INNER JOIN
                            TW_EV_DBS_MOVE.dbo.Voucher mo_Voucher WITH (NOLOCK) ON mo_Product.Id = mo_Voucher.ProductId AND 
                            mo_Product.ProgramId = mo_Voucher.ProgramId AND 
                            Account.AccountNumber = mo_Voucher.VoucherNumber INNER JOIN
                            TW_EV_DBS_MOVE.dbo.OrderBeneficiaryInfo mo_OrderBeneficiaryInfo WITH (NOLOCK) ON 
                            mo_Voucher.BeneficiaryInfoId = mo_OrderBeneficiaryInfo.Id INNER JOIN
                            TW_EV_DBS_MOVE.dbo.ProductVersion mo_ProductVersion WITH (NOLOCK) ON 
                            mo_OrderBeneficiaryInfo.ProductVersionId = mo_ProductVersion.Id LEFT JOIN
                            TW_EV_DBS_MOVE.dbo.ConsumeConfirmationInfo mo_ConsumeConfirmationInfo WITH (NOLOCK) ON 
                            mo_Voucher.Id = mo_ConsumeConfirmationInfo.VoucherId
UNION ALL
SELECT          mo_Product.ExternalProductCode AS 'product_code', Account.AccountNumber AS 'voucher_no', DATEADD(HOUR, 8, 
                            Account.ActiveTo) AS 'expired_date', (CASE mo_Product.ProductType WHEN 1 THEN
                                (SELECT          cast(round(cast(mo_ProductPricingProductBased.FaceValue AS DECIMAL) * 0.0105, 0) AS INT)
                                  FROM               TW_EV_DBS_MOVE.dbo.ProductPricingProductBased mo_ProductPricingProductBased
                                  WHERE           mo_ProductVersion.ProductPricingProductBasedId = mo_ProductPricingProductBased.Id) 
                            ELSE
                                (SELECT          cast(round(cast(mo_ProductPricingValueBased.FaceValue AS DECIMAL) * 0.0105, 0) AS INT)
                                  FROM               TW_EV_DBS_MOVE.dbo.ProductPricingValueBased mo_ProductPricingValueBased
                                  WHERE           mo_ProductVersion.ProductPricingValueBasedId = mo_ProductPricingValueBased.Id) END) 
                            AS 'product_face_value', Account.Status, Merchant.IdentityCode AS MerchantCode, 
                            Program.IdentityCode AS ProgramCode, [TransactionHistory].TranType AS action_type, 
                            [TransactionHistory].ResponseCode AS result_type, [TransactionHistory].TranLocalDateTime AS action_date, 
                            mo_ConsumeConfirmationInfo.ConfirmationInfo, mo_Voucher.Id AS voucher_id
FROM              dbo.Merchant WITH (NOLOCK) INNER JOIN
                            dbo.AcceptanceLoopMerchant WITH (NOLOCK) ON dbo.Merchant.Id = dbo.AcceptanceLoopMerchant.MerchantId INNER JOIN
                            dbo.AcceptanceLoop WITH (NOLOCK) ON dbo.AcceptanceLoopMerchant.AcceptanceLoopId = dbo.AcceptanceLoop.Id INNER JOIN
                            dbo. Product WITH (NOLOCK) ON dbo.AcceptanceLoop.ProductId = dbo. Product .Id INNER JOIN
                            dbo.Program WITH (NOLOCK) ON dbo. Product .ProgramId = dbo.Program.Id INNER JOIN
                            dbo.Account WITH (NOLOCK) ON dbo. Product .Id = dbo.Account.ProductId AND 
                            dbo.Program.Id = dbo.Account.ProgramId LEFT OUTER JOIN
                            dbo.TransactionHistory WITH (NOLOCK) ON dbo.Account.AccountNumber = dbo.TransactionHistory.AccountNumber AND 
                            dbo.Program.IdentityCode = dbo.TransactionHistory.ProgramCode LEFT OUTER JOIN
                            TW_EV_DBS_MOVE.dbo. Product mo_Product WITH (NOLOCK) ON Product .ExternalId = mo_Product.Id INNER JOIN
                            TW_EV_DBS_MOVE.dbo.Voucher mo_Voucher WITH (NOLOCK) ON mo_Product.Id = mo_Voucher.ProductId AND 
                            mo_Product.ProgramId = mo_Voucher.ProgramId AND 
                            Account.AccountNumber = mo_Voucher.VoucherNumber INNER JOIN
                            TW_EV_DBS_MOVE.dbo.OrderBeneficiaryInfo mo_OrderBeneficiaryInfo WITH (NOLOCK) ON 
                            mo_Voucher.BeneficiaryInfoId = mo_OrderBeneficiaryInfo.Id INNER JOIN
                            TW_EV_DBS_MOVE.dbo.ProductVersion mo_ProductVersion WITH (NOLOCK) ON 
                            mo_OrderBeneficiaryInfo.ProductVersionId = mo_ProductVersion.Id LEFT JOIN
                            TW_EV_DBS_MOVE.dbo.ConsumeConfirmationInfo mo_ConsumeConfirmationInfo WITH (NOLOCK) ON 
                            mo_Voucher.Id = mo_ConsumeConfirmationInfo.VoucherId
UNION ALL
SELECT          mo_Product.ExternalProductCode AS 'product_code', AccountHistory.AccountNumber AS 'voucher_no', 
                            DATEADD(HOUR, 8, AccountHistory.ActiveTo) AS 'expired_date', 
                            (CASE mo_Product.ProductType WHEN 1 THEN
                                (SELECT          cast(round(cast(mo_ProductPricingProductBased.FaceValue AS DECIMAL) * 0.0105, 0) AS INT)
                                  FROM               TW_EV_DBS_MOVE.dbo.ProductPricingProductBased mo_ProductPricingProductBased
                                  WHERE           mo_ProductVersion.ProductPricingProductBasedId = mo_ProductPricingProductBased.Id) 
                            ELSE
                                (SELECT          cast(round(cast(mo_ProductPricingValueBased.FaceValue AS DECIMAL) * 0.0105, 0) AS INT)
                                  FROM               TW_EV_DBS_MOVE.dbo.ProductPricingValueBased mo_ProductPricingValueBased
                                  WHERE           mo_ProductVersion.ProductPricingValueBasedId = mo_ProductPricingValueBased.Id) END) 
                            AS 'product_face_value', AccountHistory.Status, Merchant.IdentityCode AS MerchantCode, 
                            Program.IdentityCode AS ProgramCode, [Transaction].TranType AS action_type, 
                            [Transaction].ResponseCode AS result_type, [Transaction].TranLocalDateTime AS action_date, 
                            mo_ConsumeConfirmationInfo.ConfirmationInfo, mo_Voucher.Id AS voucher_id
FROM              dbo.Merchant WITH (NOLOCK) INNER JOIN
                            dbo.AcceptanceLoopMerchant WITH (NOLOCK) ON dbo.Merchant.Id = dbo.AcceptanceLoopMerchant.MerchantId INNER JOIN
                            dbo.AcceptanceLoop WITH (NOLOCK) ON dbo.AcceptanceLoopMerchant.AcceptanceLoopId = dbo.AcceptanceLoop.Id INNER JOIN
                            dbo. Product WITH (NOLOCK) ON dbo.AcceptanceLoop.ProductId = dbo. Product .Id INNER JOIN
                            dbo.Program WITH (NOLOCK) ON dbo. Product .ProgramId = dbo.Program.Id INNER JOIN
                            dbo.AccountHistory WITH (NOLOCK) ON dbo. Product .Id = dbo.AccountHistory.ProductId AND 
                            dbo.Program.Id = dbo.AccountHistory.ProgramId LEFT OUTER JOIN
                            dbo.[Transaction] WITH (NOLOCK) ON dbo.AccountHistory.AccountNumber = dbo.[Transaction].AccountNumber AND 
                            dbo.Program.IdentityCode = dbo.[Transaction].ProgramCode INNER JOIN
                            TW_EV_DBS_MOVE.dbo. Product mo_Product WITH (NOLOCK) ON Product .ExternalId = mo_Product.Id INNER JOIN
                            TW_EV_DBS_MOVE.dbo.Voucher mo_Voucher WITH (NOLOCK) ON mo_Product.Id = mo_Voucher.ProductId AND 
                            mo_Product.ProgramId = mo_Voucher.ProgramId AND 
                            AccountHistory.AccountNumber = mo_Voucher.VoucherNumber INNER JOIN
                            TW_EV_DBS_MOVE.dbo.OrderBeneficiaryInfo mo_OrderBeneficiaryInfo WITH (NOLOCK) ON 
                            mo_Voucher.BeneficiaryInfoId = mo_OrderBeneficiaryInfo.Id INNER JOIN
                            TW_EV_DBS_MOVE.dbo.ProductVersion mo_ProductVersion WITH (NOLOCK) ON 
                            mo_OrderBeneficiaryInfo.ProductVersionId = mo_ProductVersion.Id LEFT JOIN
                            TW_EV_DBS_MOVE.dbo.ConsumeConfirmationInfo mo_ConsumeConfirmationInfo WITH (NOLOCK) ON 
                            mo_Voucher.Id = mo_ConsumeConfirmationInfo.VoucherId
UNION ALL
SELECT          mo_Product.ExternalProductCode AS 'product_code', AccountHistory.AccountNumber AS 'voucher_no', 
                            DATEADD(HOUR, 8, AccountHistory.ActiveTo) AS 'expired_date', 
                            (CASE mo_Product.ProductType WHEN 1 THEN
                                (SELECT          cast(round(cast(mo_ProductPricingProductBased.FaceValue AS DECIMAL) * 0.0105, 0) AS INT)
                                  FROM               TW_EV_DBS_MOVE.dbo.ProductPricingProductBased mo_ProductPricingProductBased
                                  WHERE           mo_ProductVersion.ProductPricingProductBasedId = mo_ProductPricingProductBased.Id) 
                            ELSE
                                (SELECT          cast(round(cast(mo_ProductPricingValueBased.FaceValue AS DECIMAL) * 0.0105, 0) AS INT)
                                  FROM               TW_EV_DBS_MOVE.dbo.ProductPricingValueBased mo_ProductPricingValueBased
                                  WHERE           mo_ProductVersion.ProductPricingValueBasedId = mo_ProductPricingValueBased.Id) END) 
                            AS 'product_face_value', AccountHistory.Status, Merchant.IdentityCode AS MerchantCode, 
                            Program.IdentityCode AS ProgramCode, [TransactionHistory].TranType action_type, 
                            [TransactionHistory].ResponseCode result_type, [TransactionHistory].TranLocalDateTime action_date, 
                            mo_ConsumeConfirmationInfo.ConfirmationInfo, mo_Voucher.Id AS voucher_id
FROM              dbo.Merchant WITH (NOLOCK) INNER JOIN
                            dbo.AcceptanceLoopMerchant WITH (NOLOCK) ON dbo.Merchant.Id = dbo.AcceptanceLoopMerchant.MerchantId INNER JOIN
                            dbo.AcceptanceLoop WITH (NOLOCK) ON dbo.AcceptanceLoopMerchant.AcceptanceLoopId = dbo.AcceptanceLoop.Id INNER JOIN
                            dbo. Product WITH (NOLOCK) ON dbo.AcceptanceLoop.ProductId = dbo. Product .Id INNER JOIN
                            dbo.Program WITH (NOLOCK) ON dbo. Product .ProgramId = dbo.Program.Id INNER JOIN
                            dbo.AccountHistory WITH (NOLOCK) ON dbo. Product .Id = dbo.AccountHistory.ProductId AND 
                            dbo.Program.Id = dbo.AccountHistory.ProgramId LEFT OUTER JOIN
                            dbo.TransactionHistory WITH (NOLOCK) ON dbo.AccountHistory.AccountNumber = dbo.TransactionHistory.AccountNumber AND 
                            dbo.Program.IdentityCode = dbo.TransactionHistory.ProgramCode LEFT OUTER JOIN
                            TW_EV_DBS_MOVE.dbo. Product mo_Product WITH (NOLOCK) ON Product .ExternalId = mo_Product.Id INNER JOIN
                            TW_EV_DBS_MOVE.dbo.Voucher mo_Voucher WITH (NOLOCK) ON mo_Product.Id = mo_Voucher.ProductId AND 
                            mo_Product.ProgramId = mo_Voucher.ProgramId AND 
                            AccountHistory.AccountNumber = mo_Voucher.VoucherNumber INNER JOIN
                            TW_EV_DBS_MOVE.dbo.OrderBeneficiaryInfo mo_OrderBeneficiaryInfo WITH (NOLOCK) ON 
                            mo_Voucher.BeneficiaryInfoId = mo_OrderBeneficiaryInfo.Id INNER JOIN
                            TW_EV_DBS_MOVE.dbo.ProductVersion mo_ProductVersion WITH (NOLOCK) ON 
                            mo_OrderBeneficiaryInfo.ProductVersionId = mo_ProductVersion.Id LEFT JOIN
                            TW_EV_DBS_MOVE.dbo.ConsumeConfirmationInfo mo_ConsumeConfirmationInfo WITH (NOLOCK) ON 
                            mo_Voucher.Id = mo_ConsumeConfirmationInfo.VoucherId

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[19] 2[61] 3) )"
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
         Configuration = "(H (1[25] 2) )"
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
         Width = 1500
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

