
CREATE PROCEDURE [dbo].[spFixData]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TableId INT;
	DECLARE @ReimbursementValue FLOAT = 0;
	DECLARE @Bill FLOAT = 0;
	DECLARE @IIV FLOAT = 0;
	DECLARE @IV FLOAT = 0;
	DECLARE @Discount FLOAT = 0;
	DECLARE @IRV FLOAT = 0;
	DECLARE @RV FLOAT = 0;
	DECLARE @NWA FLOAT = 0;
	DECLARE @IEV FLOAT = 0;
	DECLARE @EV FLOAT = 0;
	DECLARE @NoShowPrice FLOAT = 0;
	DECLARE @NoShowCost FLOAT = 0;
	DECLARE @CostMarketing FLOAT = 0;
	DECLARE @CostEmployeeWelfare FLOAT = 0;
	DECLARE @CostTest FLOAT = 0;
	DECLARE @FNDiscount FLOAT = 0;
	DECLARE @FNNWA FLOAT = 0;
	DECLARE @FNEV FLOAT = 0;
	DECLARE @NWR FLOAT = 0;
  
  
  ---------------------------------------
  




while exists (select * from TransactionNWR)
begin

	select top 1 @TableID = id
	from TransactionNWR
	order by id asc;	

	SELECT @ReimbursementValue = dbo.F_GetReimbursementAmount(FinanceFormulaType, ReimbursementSchemeValue, TranAmount, ProductType,TranType,MGCType) FROM [TransactionNWRCalcu] WHERE Id = @TableID
	SELECT @Bill = dbo.F_GetBillAmount(FinanceFormulaType, InvoiceClient, FaceValue, TranAmount, ProductType,TranType,MGCType) FROM [TransactionNWRCalcu] WHERE Id = @TableID	
	SELECT @IIV = dbo.F_GetIIVAmount(FinanceFormulaType, FaceValue, TranType, TranAmount, ProductType, BalanceAvailable,MGCType) FROM [TransactionNWRCalcu] WHERE Id = @TableID
	SELECT @IV = dbo.F_GetIVAmount(FinanceFormulaType, FaceValue, TranType, TranAmount, ProductType, BalanceAvailable, MGCType) FROM [TransactionNWRCalcu] WHERE Id = @TableID 
	SELECT @Discount = dbo.F_GetDiscountAmount(FinanceFormulaType, FaceValue, TranType, TranAmount, ProductType, SoldPrice, BalanceAvailable,MGCType) FROM [TransactionNWRCalcu] WHERE Id = @TableID 
	SELECT @IRV = dbo.F_GetIRVAmount(FinanceFormulaType, FaceValue, TranType, TranAmount, ProductType,MGCType) FROM [TransactionNWRCalcu] WHERE Id = @TableID
	SELECT @RV = dbo.F_GetRVAmount(FinanceFormulaType, FaceValue, TranType, TranAmount, ProductType,MGCType) FROM [TransactionNWRCalcu] WHERE Id = @TableID
	SELECT @NWA = dbo.F_GetNWAAmount(FinanceFormulaType, FaceValue, TranType, TranAmount, ProductType, Cost, ReimbursementSchemeValue, BalanceAvailable,MGCType) FROM [TransactionNWRCalcu] WHERE Id = @TableID
	SELECT @IEV = dbo.F_GetIEVAmount(FinanceFormulaType, FaceValue, TranType, TranAmount, ProductType,MGCType) FROM [TransactionNWRCalcu] WHERE Id = @TableID 
	SELECT @EV = dbo.F_GetEVAmount(FinanceFormulaType, FaceValue, TranType, TranAmount, ProductType, BalanceAvailable,MGCType) FROM [TransactionNWRCalcu] WHERE Id = @TableID 
	SELECT @NoShowPrice = dbo.F_GetNoShowPriceAmount(FinanceFormulaType, InvoiceClient, TranType, TranAmount, ProductType,MGCType) FROM [TransactionNWRCalcu] WHERE Id = @TableID 
	SELECT @NoShowCost = dbo.F_GetNoShowCostAmount(FinanceFormulaType, ReimbursementSchemeValue, TranType, TranAmount, ProductType,MGCType) FROM [TransactionNWRCalcu] WHERE Id = @TableID
	SELECT @CostMarketing = dbo.F_GetCostMarketingAmount(FinanceFormulaType, ReimbursementSchemeValue, TranType, TranAmount, ProductType,MGCType) FROM [TransactionNWRCalcu] WHERE Id = @TableID
	SELECT @CostEmployeeWelfare = dbo.F_GetCostEmployeeWelfareAmount(FinanceFormulaType, ReimbursementSchemeValue, TranType, TranAmount, ProductType,MGCType) FROM [TransactionNWRCalcu] WHERE Id = @TableID 
	SELECT @CostTest = dbo.F_GetCostTestAmount(FinanceFormulaType, ReimbursementSchemeValue, TranType, TranAmount, ProductType,MGCType) FROM [TransactionNWRCalcu] WHERE Id = @TableID 
	SELECT @FNDiscount = dbo.F_GetFinanceDiscountAmount(FinanceFormulaType, FaceValue, TranType, TranAmount, ProductType, SoldPrice, MultipleSelectionType,MGCType) FROM [TransactionNWRCalcu] WHERE Id = @TableID
	SELECT @FNNWA = dbo.F_GetFNNWAAmount(FinanceFormulaType, FaceValue, TranType, BalanceAvailable, ProductType, Cost) FROM [TransactionNWRCalcu] WHERE Id = @TableID
	SELECT @FNEV = dbo.F_GetFNEVAmount(FinanceFormulaType, FaceValue, TranType, ProductType, BalanceAvailable) FROM [TransactionNWRCalcu] WHERE Id = @TableID
	SELECT @NWR = dbo.F_GetNWRAmount(FinanceFormulaType, FaceValue, TranType, TranAmount, ProductType, ReimbursementSchemeValue, ReimbursementSchemeValue,MGCType) FROM [TransactionNWRCalcu] WHERE Id = @TableID


	UPDATE dbo.[Transaction]
	SET ReimbursementValue = @ReimbursementValue,
	Bill = @Bill,
	IIV = @IIV,
	IV = @IV,
	Discount = @Discount,
	IRV = @IRV,
	RV = @RV,
	NWA = @NWA,
	IEV = @IEV,
	EV = @EV,
	NoShowPrice = @NoShowPrice,
	NoShowCost = @NoShowCost,
	CostMarketing = @CostMarketing,
	CostEmployeeWelfare = @CostEmployeeWelfare,
	CostTest = @CostTest,
	FNDiscount = @FNDiscount,
	FNNWa = @FNNWA,
	FNEV = @FNEV,
	NWR = @NWR	
	WHERE Id = @TableId

	delete TransactionNWR where id = @TableID;

end	
 
  

  ---------------------------------------
END
