
CREATE PROCEDURE [dbo].[spDataFixingPreparing]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		TT.Id,
		TT.TranType AS TranType, 
		TT.TranAmount AS TranAmount, 
		BM.FinanceFormulaType AS FinanceFormulaType, 
		MCS.ReimbursementSchemeValue AS ReimbursementSchemeValue, 
		PD.ProductType AS ProductType, 
		CASE
			WHEN ProductType = 1
			THEN PPPB.FaceValue
			ELSE PPVB.FaceValue
		END AS FaceValue, 
		CASE
			WHEN PD.IsMasterProduct = 1 THEN 'M'
			WHEN VC.ChildVoucherId IS NULL THEN 'G'
			ELSE 'C'
		END AS MGCType, --M:Master Voucher; G:General Vocher; C:Child Voucher
		CASE
			WHEN PD.ProductType = 1
			THEN PPPB.Cost
			ELSE PPVB.MerchantFee
		END AS Cost, 
		0.000000 AS NWR,
		TT.BalanceAvailable,
		CQPC.InvoiceClient,
		CQPSP.SoldPriceWithoutTax AS SoldPrice,
		PD.MultipleSelectionType
	INTO [dbo].[TransactionNWRCalcu]
	FROM dbo.[TransactionNWR] TT
		LEFT JOIN dbo.Merchant M WITH(NOLOCK) ON TT.MerchantCode = M.IdentityCode
		--LEFT JOIN dbo.Shop S WITH(NOLOCK) ON TT.ShopCode = S.IdentityCode
		INNER JOIN dbo.Program PG WITH(NOLOCK) ON TT.ProgramCode = PG.IdentityCode
		INNER JOIN dbo.Voucher V WITH(NOLOCK) ON TT.AccountNumber = V.VoucherNumber
												AND PG.Id = V.ProgramId
		LEFT JOIN dbo.VoucherCombo VC WITH(NOLOCK) ON VC.ChildVoucherId = V.Id --change
													AND VC.STATUS = 1 --change
		INNER JOIN dbo.OrderBeneficiaryInfo OBI WITH(NOLOCK) ON V.BeneficiaryInfoId = OBI.Id
		INNER JOIN dbo.OrderLine OL WITH(NOLOCK) ON OBI.OrderLineId = OL.Id
		INNER JOIN dbo.Dictionary D WITH(NOLOCK) ON TT.TranType = D.NAME
													AND D.Category = 'TransactionType'
		LEFT JOIN dbo.ClientQuotationPricing CQPC WITH (NOLOCK, INDEX = [IDX_ClientQuotationPricing_Validity]) ON OL.ClientQuotationProductId = CQPC.ClientQuotationProductId
																												AND D.Id = CQPC.TransactionTypeId
																												AND CQPC.[ValidityFrom] <= OBI.[ActiveDate]
																												AND CQPC.[ValidityEnd] >= OBI.[ActiveDate]
		INNER JOIN dbo.ClientQuotationProduct CQPD WITH(NOLOCK) ON CQPD.Id = OL.ClientQuotationProductId
		INNER JOIN dbo.ClientQuotationProductSoldPrice CQPSP WITH (NOLOCK, INDEX = [IDX_ClientQuotationProductSoldPrice_Validity]) ON CQPD.Id = CQPSP.ClientQuotationProductId
																																	AND CQPSP.[ValidityFrom] <= OBI.[ActiveDate]
																																	AND CQPSP.[ValidityEnd] >= OBI.[ActiveDate]
																																	AND CQPSP.STATUS = 2
		INNER JOIN dbo.ClientQuotation CQ WITH(NOLOCK) ON CQ.Id = CQPD.ClientQuotationId
		INNER JOIN dbo.BusinessModel BM WITH(NOLOCK) ON CQ.BusinessModelId = BM.Id
		--LEFT JOIN dbo.BusinessModelTransactionType BMTT WITH(NOLOCK) ON BMTT.TransactionTypeId = D.Id
		--                                                                AND BMTT.BusinessModelId = CQ.BusinessModelId
		INNER JOIN dbo.ProductVersion PV WITH(NOLOCK) ON OBI.ProductVersionId = PV.Id
		INNER JOIN dbo.Product PD WITH(NOLOCK) ON PV.ProductId = PD.Id
		LEFT JOIN dbo.ProductPricingProductBased PPPB WITH(NOLOCK) ON PV.ProductPricingProductBasedId = PPPB.Id
		LEFT JOIN dbo.ProductPricingValueBased PPVB WITH(NOLOCK) ON PV.ProductPricingValueBasedId = PPVB.Id
		LEFT JOIN (
		-- Get all merchant contract with all product version.
		SELECT MC.MerchantId AS MerchantId, 
			PD.Id AS ProductId, 
			RS.TransactionTypeId AS TransactionTypeId, 
			RS.Id AS ReimbursementSchemeId, 
			RS.Value AS ReimbursementSchemeValue, 
			MC.ValidFrom AS ValidFrom, 
			MC.ValidTo AS ValidTo
		FROM MerchantContract MC WITH(NOLOCK)
			INNER JOIN dbo.ProductVersion PV WITH(NOLOCK) ON MC.ProductVersionId = PV.Id
			INNER JOIN dbo.Product PD WITH(NOLOCK) ON PV.ProductId = PD.Id
			INNER JOIN dbo.ReimbursementScheme RS WITH(NOLOCK) ON RS.MerchantContractId = MC.Id
	) AS MCS ON MCS.MerchantId = M.Id
				AND MCS.ProductId = PD.Id
				AND ISNULL(TT.SettleDate, TT.TranLocalDate) >= CAST(CONVERT(VARCHAR(10), MCS.ValidFrom, 112) AS INT)
				AND ISNULL(TT.SettleDate, TT.TranLocalDate) <= CAST(CONVERT(VARCHAR(10), MCS.ValidTo, 112) AS INT)
				AND MCS.TransactionTypeId = D.Id

END
