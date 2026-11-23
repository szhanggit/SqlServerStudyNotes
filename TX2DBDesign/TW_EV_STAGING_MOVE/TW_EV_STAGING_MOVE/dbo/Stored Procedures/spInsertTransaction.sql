CREATE PROCEDURE dbo.spInsertTransaction
	@ErrorMessage NVARCHAR(4000) OUTPUT
	,@ErrorLine INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY
		TRUNCATE TABLE dbo.TransactionFeeBuffer;
            DELETE FROM dbo.TransactionBuffer;
			
			DECLARE @instace VARCHAR(20) = NULL;
			SELECT @instace = ConfigValue FROM dbo.InstanceConfig WITH(NOLOCK) WHERE ConfigName = 'InstanceName';

            -- Get largest ID from transaction table.
            DECLARE @MaxId BIGINT;
            SELECT @MaxId = MAX(Id)
            FROM [dbo].[Transaction];
			
            WITH Transaction_CTE(AccountNumber, 
                                 ProgramCode, 
                                 MerchantCode, 
                                 ShopCode, 
                                 TranType, 
                                 TranLocalDate, 
                                 TranLocalDateTime, 
                                 SettleDate, 
                                 TranRealDateTime, 
                                 [Status], 
                                 TranAmount, 
                                 RefundedAmount, 
                                 ResponseCode, 
                                 Channel, 
                                 TranCode, 
                                 TranCodeRef, 
                                 BalanceAvailable, 
                                 BalanceFrozen, 
                                 MerchantId, 
                                 ShopId, 
                                 ClientQuotationProductId, 
                                 ProductId, 
                                 OrderId, 
                                 ClientQuotationPricingId, 
                                 ReimbursementSchemeId, 
                                 TranTypeId, 
                                 FinanceFormulaType, 
                                 ReimbursementSchemeValue, 
                                 ProductType, 
                                 InvoiceClient, 
                                 FaceValue, 
                                 SystemProcessFee, 
                                 SoldPrice, 
                                 Cost, 
                                 Rsv1, 
                                 Rsv2, 
                                 Rsv3, 
                                 ServiceFeeType, 
                                 TerminalSSN, 
                                 ShiftCode, 
                                 BusinessDay, 
                                 TerminalCode, 
                                 MultipleSelectionType,
								 MGCType,
								 PreTranType,
								 InitBalance,
								 LEBalance,
								 LEInitBalance)
                 AS (SELECT TT.AccountNumber AS AccountNumber, 
                            TT.ProgramCode AS ProgramCode, 
                            TT.MerchantCode AS MerchantCode, 
                            TT.ShopCode AS ShopCode, 
                            TT.TranType AS TranType, 
                            TT.TranLocalDate AS TranLocalDate, 
                            TT.TranLocalDateTime AS TranLocalDateTime, 
                            ISNULL(TT.SettleDate, TT.TranLocalDate) AS SettleDate, 
                            TT.TranRealDateTime AS TranRealDateTime, 
                            TT.[Status] AS [Status], 
                            TT.TranAmount AS TranAmount, 
                            TT.RefundedAmount AS RefundedAmount, 
                            TT.ResponseCode AS ResponseCode, 
                            TT.Channel AS Channel, 
                            TT.TranCode AS TranCode, 
                            TT.TranCodeRef AS TranCodeRef, 
                            TT.BalanceAvailable AS BalanceAvailable, 
                            TT.BalanceFrozen AS BalanceFrozen, 
                            M.Id AS MerchantId, 
                            S.Id AS ShopId, 
                            OL.ClientQuotationProductId AS ClientQuotationProductId, 
                            V.ProductId AS ProductId, 
                            OL.OrderId AS OrderId, 
                            CQPC.Id AS ClientQuotationPricingId, 
                            MCS.ReimbursementSchemeId AS ReimbursementSchemeId, 
                            D.Id AS TranTypeId, 
                            BM.FinanceFormulaType AS FinanceFormulaType, 
                            MCS.ReimbursementSchemeValue AS ReimbursementSchemeValue, 
                            PD.ProductType AS ProductType, 
                            CQPC.InvoiceClient AS InvoiceClient, --Change
							CASE 
								WHEN ProductType = 1 THEN PPPB.FaceValue
								WHEN ProductType = 2 THEN IIF(PD.ProductSubType = 4, OBI.FaceValue, PPVB.FaceValue)
								ELSE 0 
							END AS [FaceValue],
                            CQPD.SystemProcessFee AS SystemProcessFee,  
							CASE
								WHEN ProductType = 1 THEN CQPSP.SoldPriceWithoutTax
								WHEN ProductType = 2 THEN IIF(PD.ProductSubType = 4, OBI.SoldPrice, ISNULL(CQPSP.ValueBasedSoldPriceWithoutTax, CQPSP.SoldPriceWithoutTax))
								ELSE 0
							END AS [SoldPrice],
							CASE 
								WHEN ProductType = 1 THEN PPPB.Cost
								WHEN ProductType = 2 THEN IIF(PD.ProductSubType = 4, PPDFV.DefaultProductCost, PPVB.MerchantFee)
								ELSE 0.0
							END AS [Cost],
                            Rsv1 AS Rsv1, 
                            Rsv2 AS Rsv2, 
                            Rsv3 AS Rsv3, 
                            CQ.ServiceFeeType AS ServiceFeeType, 
                            TT.TerminalSSN, 
                            TT.ShiftCode, 
                            TT.BusinessDay, 
                            TT.TerminalCode, 
                            PD.MultipleSelectionType,
							CASE
								WHEN PD.IsMasterProduct = 1 THEN 'M'
                                WHEN VC.ChildVoucherId IS NULL THEN 'G'
                                ELSE 'C'
                            END AS MGCType, --M:Master Voucher; G:General Vocher; C:Child Voucher
							TT.PreTranType,
							TT.InitBalance,
							TT.LEBalance,
							TT.LEInitBalance
                     FROM dbo.TransactionToSync TT
                          LEFT JOIN dbo.Merchant M WITH(NOLOCK) ON TT.MerchantCode = M.IdentityCode
                          LEFT JOIN dbo.Shop S WITH(NOLOCK) ON TT.ShopCode = S.IdentityCode AND S.MerchantId = M.id
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
                          LEFT JOIN dbo.BusinessModelTransactionType BMTT WITH(NOLOCK) ON BMTT.TransactionTypeId = D.Id
                                                                                          AND BMTT.BusinessModelId = CQ.BusinessModelId
                          INNER JOIN dbo.ProductVersion PV WITH(NOLOCK) ON OBI.ProductVersionId = PV.Id
                          INNER JOIN dbo.Product PD WITH(NOLOCK) ON PV.ProductId = PD.Id
                          LEFT JOIN dbo.ProductPricingProductBased PPPB WITH(NOLOCK) ON PV.ProductPricingProductBasedId = PPPB.Id
                          LEFT JOIN dbo.ProductPricingValueBased PPVB WITH(NOLOCK) ON PV.ProductPricingValueBasedId = PPVB.Id
                          LEFT JOIN dbo.ProductPricingDynamicFaceValue PPDFV WITH(NOLOCK) ON PV.Id = PPDFV.ProductVersionId
                          LEFT JOIN
                     (
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
                     )
					 
					 
					 
                 INSERT INTO dbo.[TransactionBuffer]
                 (AccountNumber, 
                  ProgramCode, 
                  MerchantCode, 
                  ShopCode, 
                  TranType, 
                  TranLocalDate, 
                  TranLocalDateTime, 
                  SettleDate, 
                  TranRealDateTime, 
                  [Status], 
                  TranAmount, 
                  RefundedAmount, 
                  ResponseCode, 
                  Channel, 
                  TranCode, 
                  TranCodeRef, 
                  BalanceAvailable, 
                  BalanceFrozen, 
                  MerchantId, 
                  ShopId, 
                  ClientQuotationProductId, 
                  ProductId, 
                  OrderId, 
                  ClientQuotationPricingId, 
                  ReimbursementSchemeId,
                  --,InvoiceValue 
                  ReimbursementValue, 
                  Bill,
                  --,ServiceFee 
                  IIV, 
                  IV, 
                  Discount, 
                  IRV, 
                  RV, 
                  NWR, 
                  NWA, 
                  IEV, 
                  EV, 
                  NoShowPrice, 
                  NoShowCost, 
                  CostMarketing, 
                  CostEmployeeWelfare, 
                  CostTest, 
                  Rsv1, 
                  Rsv2, 
                  Rsv3, 
                  TerminalSSN, 
                  ShiftCode, 
                  BusinessDay, 
                  TerminalCode, 
                  FNDiscount, 
                  FNNWA, 
                  FNEV,
				  MGCType,
				  FNEVWithhold,
				  
				  FNEVDiscount,
				  FNEVWithholdDiscount
                 )
                        SELECT AccountNumber, 
                               ProgramCode, 
                               MerchantCode, 
                               ShopCode, 
                               TranType, 
                               TranLocalDate, 
                               TranLocalDateTime, 
                               SettleDate, 
                               TranRealDateTime, 
                               [Status], 
                               TranAmount, 
                               RefundedAmount, 
                               ResponseCode, 
                               Channel, 
                               TranCode, 
                               TranCodeRef, 
                               BalanceAvailable, 
                               BalanceFrozen, 
                               MerchantId, 
                               ShopId, 
                               ClientQuotationProductId, 
                               ProductId, 
                               OrderId, 
                               ClientQuotationPricingId, 
                               ReimbursementSchemeId,
                               --,Bill + ServiceFee AS InvoiceValue 
                               ReimbursementValue, 
                               Bill,
                               --,ServiceFee 
                               IIV, 
                               IV, 
                               Discount, 
                               IRV, 
                               RV, 
                               NWR, 
                               NWA, 
                               IEV, 
                               EV, 
                               NoShowPrice, 
                               NoShowCost, 
                               CostMarketing, 
                               CostEmployeeWelfare, 
                               CostTest, 
                               Rsv1, 
                               Rsv2, 
                               Rsv3, 
                               TerminalSSN, 
                               ShiftCode, 
                               BusinessDay, 
                               TerminalCode, 
                               FNDiscount, 
                               FNNWA, 
                               FNEV,
							   MGCType,
							   FNEVWithhold,
							   
							   FNEVDiscount,
							   FNEVWithholdDiscount
                        FROM
                        (
                            SELECT TS.*, 
                                   --NWR,
                                   iif( FRTM.ForwardTranId is null , dbo.F_GetNWRAmount(FinanceFormulaType, FaceValue, TranType, TranAmount, ProductType, ReimbursementSchemeValue, ReimbursementSchemeValue,MGCType,@instace) , null ) AS NWR, 
                                   dbo.F_GetReimbursementAmount(FinanceFormulaType, TS.ReimbursementSchemeValue, TranAmount, ProductType,TranType,MGCType,@instace) AS ReimbursementValue, 
                                   dbo.F_GetBillAmount(FinanceFormulaType, InvoiceClient, FaceValue, TranAmount, ProductType,TranType,MGCType,@instace) AS Bill,
                                   dbo.F_GetIIVAmount(FinanceFormulaType, FaceValue, TranType, TranAmount, ProductType, BalanceAvailable,MGCType,@instace) AS IIV, 
                                   dbo.F_GetIVAmount(FinanceFormulaType, FaceValue, TranType, TranAmount, ProductType, BalanceAvailable,MGCType,@instace) AS IV, 
                                   dbo.F_GetDiscountAmount(FinanceFormulaType, FaceValue, TranType, TranAmount, ProductType, SoldPrice, BalanceAvailable,MGCType,@instace) AS Discount, 
                                   dbo.F_GetIRVAmount(FinanceFormulaType, FaceValue, TranType, TranAmount, ProductType,MGCType,@instace) AS IRV, 
                                   dbo.F_GetRVAmount(FinanceFormulaType, FaceValue, TranType, TranAmount, ProductType,MGCType,@instace) AS RV, 
                                   dbo.F_GetNWAAmount(FinanceFormulaType, FaceValue, TranType, TranAmount, ProductType, Cost, ReimbursementSchemeValue, BalanceAvailable,MGCType,@instace) AS NWA, 
                                   dbo.F_GetIEVAmount(FinanceFormulaType, FaceValue, TranType, TranAmount, ProductType,MGCType,@instace) AS IEV, 
                                   dbo.F_GetEVAmount(FinanceFormulaType, FaceValue, TranType, TranAmount, ProductType, BalanceAvailable,MGCType,@instace) AS EV, 
                                   dbo.F_GetNoShowPriceAmount(FinanceFormulaType, InvoiceClient, TranType, TranAmount, ProductType,MGCType,@instace) AS NoShowPrice, 
                                   dbo.F_GetNoShowCostAmount(FinanceFormulaType, TS.ReimbursementSchemeValue, TranType, TranAmount, ProductType,MGCType,@instace) AS NoShowCost, 
                                   dbo.F_GetCostMarketingAmount(FinanceFormulaType, TS.ReimbursementSchemeValue, TranType, TranAmount, ProductType,MGCType,@instace) AS CostMarketing, 
                                   dbo.F_GetCostEmployeeWelfareAmount(FinanceFormulaType, TS.ReimbursementSchemeValue, TranType, TranAmount, ProductType,MGCType,@instace) AS CostEmployeeWelfare, 
                                   dbo.F_GetCostTestAmount(FinanceFormulaType, TS.ReimbursementSchemeValue, TranType, TranAmount, ProductType,MGCType,@instace) AS CostTest, 
                                   dbo.F_GetFinanceDiscountAmount(FinanceFormulaType, FaceValue, TranType, TranAmount, ProductType, SoldPrice, MultipleSelectionType,MGCType,@instace) AS FNDiscount, 
                                   dbo.F_GetFNNWAAmount(FinanceFormulaType, FaceValue, SoldPrice, TranType, ProductType, TranAmount, PreTranType, InitBalance, LEInitBalance, BalanceAvailable, Cost) AS FNNWA, 
                                   dbo.F_GetFNEVAmount(FinanceFormulaType, FaceValue, TranType, ProductType, PreTranType, LEInitBalance, @instace) AS FNEV,							
								   dbo.F_GetFNEVWithholdAmount(FinanceFormulaType, FaceValue, TranType, ProductType, TranAmount, PreTranType, InitBalance, LEInitBalance,@instace) AS FNEVWithhold,
								   dbo.F_GetFNEVDiscount(FinanceFormulaType, FaceValue, SoldPrice, TranType, ProductType, PreTranType, LEInitBalance,@instace) AS FNEVDiscount,
								   dbo.F_GetFNEVWithholdDiscount(FinanceFormulaType, FaceValue, SoldPrice, TranType, ProductType, TranAmount, PreTranType, InitBalance, LEInitBalance, @instace) AS FNEVWithholdDiscount
                            FROM Transaction_CTE TS
                            LEFT JOIN [dbo].[ForwardReverseTranMapping] FRTM WITH(NOLOCK) ON FRTM.ReverseTranId = TranTypeId) As S;
                                 --LEFT JOIN
                            --(
                                ---- Calculate NWR for the transaction which can be reversed.
                                --SELECT AccountNumber, 
                                --       TranCode, 
                                --       dbo.F_GetNWRAmount(FinanceFormulaType, FaceValue, TranType, TranAmount, ProductType, ReimbursementSchemeValue, ReimbursementSchemeValue,MGCType,@instace) AS NWR
                                --FROM Transaction_CTE TC
                                --     LEFT JOIN [dbo].[ForwardReverseTranMapping] FRTM WITH(NOLOCK) ON FRTM.ReverseTranId = TranTypeId
                                --WHERE FRTM.ForwardTranId IS NULL
                            --) AS CR ON TS.AccountNumber = CR.AccountNumber
                                       --AND TS.TranCode = CR.TranCode
                        --) AS S;	

						
						
						
            INSERT INTO dbo.TransactionFeeBuffer
                   SELECT tb.Id, 
                          cqpsf.ServiceFeeId, 
                          dbo.F_GetServiceFeeAmountNew(cqpsf.ServiceFeeId, cqpsf.CalculationRule,cqpsf.CalculationExpression, tb.TranType, cqpsf.SoldPrice, 1,MGCType, OBI.Mobile, @instace) AS TranFee,
						  dbo.F_GetServiceFeeAmountWithTaxNew(cqpsf.ServiceFeeId, cqpsf.CalculationRule,cqpsf.CalculationExpression, tb.TranType, cqpsf.SoldPriceWithTax, 1,MGCType, OBI.Mobile, @instace) AS TranFeeWithTax,
						  dbo.F_GetServiceFeeValid(cqpsf.ServiceFeeId, cqpsf.CalculationRule,cqpsf.CalculationExpression,OBI.Email,OBI.Mobile, @instace) AS IsValid
                   FROM dbo.TransactionBuffer AS tb WITH(NOLOCK)
                        INNER JOIN dbo.Program PG WITH(NOLOCK) ON tb.ProgramCode = PG.IdentityCode
                        INNER JOIN dbo.Voucher V WITH(NOLOCK) ON tb.AccountNumber = V.VoucherNumber
                                                                 AND PG.Id = V.ProgramId
                        INNER JOIN dbo.OrderBeneficiaryInfo OBI WITH(NOLOCK) ON V.BeneficiaryInfoId = OBI.Id
                        INNER JOIN
                   (
                       SELECT sf.Id AS ServiceFeeId, 
                              sf.CalculationRule,
                              sf.CalculationExpression,
                              sftt.TranType, 
                              cqpsftt.ClientQuotationProductId, 
                              cqpsftt.SoldPrice, --Change
							  cqpsftt.SoldPriceWithTax,
                              cqpsftt.[ValidityFrom], 
                              cqpsftt.[ValidityEnd], 
                              cqpsftt.[Status]
                       FROM dbo.ClientQuotationProductServiceFeeTriggerTime AS cqpsftt WITH(NOLOCK)
                            INNER JOIN dbo.ServiceFeeTriggerTime AS sftt WITH(NOLOCK) ON sftt.Id = cqpsftt.ServiceFeeTriggerTimeId
                            INNER JOIN dbo.ServiceFee AS sf WITH(NOLOCK) ON sf.Id = sftt.ServiceFeeId
                                                                            AND sf.STATUS = 1                                                   
						UNION
						SELECT sf.Id AS ServiceFeeId, 
                              sf.CalculationRule,
                              sf.CalculationExpression, 
                              501, 
                              cqpsftt.ClientQuotationProductId, 
                              cqpsftt.SoldPrice * -1, --Change
							  cqpsftt.SoldPriceWithTax,
                              cqpsftt.[ValidityFrom], 
                              cqpsftt.[ValidityEnd], 
                              cqpsftt.[Status]
                       FROM dbo.ClientQuotationProductServiceFeeTriggerTime AS cqpsftt WITH(NOLOCK)
                            INNER JOIN dbo.ServiceFeeTriggerTime AS sftt WITH(NOLOCK) ON sftt.Id = cqpsftt.ServiceFeeTriggerTimeId
                            INNER JOIN dbo.ServiceFee AS sf WITH(NOLOCK) ON sf.Id = sftt.ServiceFeeId
                                                                            AND sf.STATUS = 1
					   WHERE sftt.TranType = 401
                   ) AS cqpsf ON tb.ClientQuotationProductId = cqpsf.ClientQuotationProductId
                                 AND tb.TranType = cqpsf.TranType
                   WHERE cqpsf.[ValidityFrom] <= OBI.[ActiveDate]
                         AND cqpsf.[ValidityEnd] >= OBI.[ActiveDate]
                         AND cqpsf.[Status] = 2;
						 
						 
						 
						 
            UPDATE tb
              SET 
                  ServiceFee = ISNULL(tbf.TranFee, 0.0), 
                  InvoiceValue = Bill + ISNULL(tbf.TranFee, 0.0)
            FROM dbo.TransactionBuffer AS tb
                 LEFT JOIN
            (
                SELECT TransactionBufferId, 
                       SUM(TranFee) AS TranFee
                FROM dbo.TransactionFeeBuffer
                GROUP BY TransactionBufferId
            ) AS tbf ON tb.Id = tbf.TransactionBufferId;
			
			
			
			
			
            INSERT INTO dbo.[Transaction]
            (AccountNumber, 
             ProgramCode, 
             MerchantCode, 
             ShopCode, 
             TranType, 
             TranLocalDate, 
             TranLocalDateTime, 
             SettleDate, 
             TranRealDateTime, 
             STATUS, 
             TranAmount, 
             RefundedAmount, 
             ResponseCode, 
             Channel, 
             TranCode, 
             TranCodeRef, 
             BalanceAvailable, 
             BalanceFrozen, 
             MerchantId, 
             ShopId, 
             ClientQuotationProductId, 
             ProductId, 
             OrderId, 
             InvoiceToBeRequestedId, 
             ClientQuotationPricingId, 
             ReimbursementSchemeId, 
             ReimbursementLineId, 
             InvoiceValue, 
             ReimbursementValue, 
             Bill, 
             ServiceFee, 
             IIV, 
             IV, 
             Discount, 
             IRV, 
             RV, 
             NWR, 
             NWA, 
             IEV, 
             EV, 
             NoShowPrice, 
             NoShowCost, 
             CostMarketing, 
             CostEmployeeWelfare, 
             CostTest, 
             Rsv1, 
             Rsv2, 
             Rsv3, 
             TerminalSSN, 
             ShiftCode, 
             BusinessDay, 
             TerminalCode, 
             FNDiscount, 
             FNNWA, 
             FNEV,
			 FNEVWithhold,
			 
			 FNEVDiscount,
			 FNEVWithholdDiscount
            )
                   SELECT AccountNumber, 
                          ProgramCode, 
                          MerchantCode, 
                          ShopCode, 
                          TranType, 
                          TranLocalDate, 
                          TranLocalDateTime, 
                          SettleDate, 
                          TranRealDateTime, 
                          STATUS, 
                          TranAmount, 
                          RefundedAmount, 
                          ResponseCode, 
                          Channel, 
                          TranCode, 
                          TranCodeRef, 
                          BalanceAvailable, 
                          BalanceFrozen, 
                          MerchantId, 
                          ShopId, 
                          ClientQuotationProductId, 
                          ProductId, 
                          OrderId, 
                          InvoiceToBeRequestedId, 
                          ClientQuotationPricingId, 
                          ReimbursementSchemeId, 
                          ReimbursementLineId, 
                          InvoiceValue, 
                          ReimbursementValue, 
                          Bill, 
                          ServiceFee, 
                          IIV, 
                          IV, 
                          Discount, 
                          IRV, 
                          RV, 
                          NWR, 
                          NWA, 
                          IEV, 
                          EV, 
                          NoShowPrice, 
                          NoShowCost, 
                          CostMarketing, 
                          CostEmployeeWelfare, 
                          CostTest, 
                          Rsv1, 
                          Rsv2, 
                          Rsv3, 
                          TerminalSSN, 
                          ShiftCode, 
                          BusinessDay, 
                          TerminalCode, 
                          FNDiscount, 
                          FNNWA, 
                          FNEV,
						  FNEVWithhold,
						  
						  FNEVDiscount,
						  FNEVWithholdDiscount						  
                   FROM dbo.TransactionBuffer;
				   			 				 				 
            INSERT INTO dbo.TransactionFee
                   SELECT t.Id, 
                          tfb.ServiceFeeId, 
                          tfb.TranFee,
						  tfb.TranFeeWithTax,
						  tfb.IsValid
                   FROM dbo.[Transaction] AS t WITH(NOLOCK)
                        INNER JOIN dbo.TransactionBuffer AS tb WITH(NOLOCK) ON t.AccountNumber = tb.AccountNumber
                                                                               AND t.TranCode = tb.TranCode
                        INNER JOIN dbo.TransactionFeeBuffer AS tfb WITH(NOLOCK) ON tb.Id = tfb.TransactionBufferId;
						
						
						
			--Optimization Dec 19th, 2019		
			DELETE FROM TransactionShadow;

			insert into TransactionShadow ([TransactionId], [AccountNumber], [TrAccountNumber], [TranCode], [TrTranCode], [TranCodeRef], [NWR], [TRNWR], [TranType], [TRTranType], [ResponseCode], [TRResponseCode], [Status])
			select T.Id, T.AccountNumber, TR.AccountNumber, T.TranCode, TR.TranCode, T.TranCodeRef, T.NWR, TR.NWR, T.TranType, TR.TranType, T.[ResponseCode], TR.[ResponseCode], T.[Status] 
			FROM dbo.[TransactionBuffer] AS TR WITH(NOLOCK)
			INNER JOIN dbo.[transaction] AS T WITH(NOLOCK) ON T.AccountNumber = TR.AccountNumber AND T.TranCode = TR.TranCodeRef AND TR.ResponseCode = '0000'											
											
			UPDATE TransactionShadow
			set TRNWR = -1 * NWR
			where TranType not in (102,116,117);	
						
			UPDATE t1
			set t1.NWR = t2.TRNWR
			from [Transaction] t1 with(nolock) inner join TransactionShadow t2 with(nolock) on t1.AccountNumber = t2.TrAccountNumber AND t1.TranCode = t2.TrTranCode						
			where t1.TranType not in (117,116);
			
			update TransactionShadow
			set [Status] = 2 
			from TransactionShadow with(nolock) 
			where [Status] = 1 
			AND TRTranType != 103
			AND TRTranType != 106
			AND TRTranType != 116
			AND TranType != 104
			AND TRResponseCode = '0000';
			
			UPDATE t1
			set t1.[Status] = t2.[Status]
			from [Transaction] t1 with(nolock) inner join TransactionShadow t2 with(nolock) on t1.Id = t2.TransactionId								

            DELETE FROM dbo.TransactionToSync;
            TRUNCATE TABLE dbo.TransactionFeeBuffer;
            DELETE FROM dbo.TransactionBuffer;;
			DELETE FROM TransactionShadow;

	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorLine = ERROR_LINE();
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;
	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END;