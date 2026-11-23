
CREATE PROCEDURE [dbo].[spUpdateDiscount_Temp]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY
		DECLARE @CurrentDateTime INT
		SET @CurrentDateTime = DATEPART(HOUR, GETDATE())%12

		;with cte as (
		select t.Id, t.FNDiscount, case when q.BusinessModelId = 4 then 2 else 1 end as FinanceFormulaType, FaceValue, TranType, TranAmount, p.ProductType, ValueBasedSoldPriceWithoutTax, p.MultipleSelectionType
		from [Transaction] t with(nolock)
		join Product p with(nolock) on p.Id = t.ProductId
		join ClientQuotationProduct cqp with(nolock) on cqp.Id = t.ClientQuotationProductId
		join Program g with(nolock) on g.IdentityCode = t.ProgramCode
		join Voucher v with(nolock) on v.VoucherNumber = t.AccountNumber and v.ProgramId = g.Id
		join OrderBeneficiaryInfo obi with(nolock) on obi.Id = v.BeneficiaryInfoId
		join ClientQuotationProductSoldPrice cqps with(nolock) on cqps.ClientQuotationProductId = cqp.Id and cqps.ValidityFrom <= obi.ActiveDate and cqps.ValidityEnd > obi.ActiveDate
		join ClientQuotation q with(nolock) on q.Id = cqp.ClientQuotationId
		join ClientQuotationProductCombo cqpc with(nolock) on cqpc.ChildClientQuotationProductId = cqp.Id
		join ProductVersion pv with(nolock) on pv.Id = cqp.ProductVersionId
		join ProductPricingValueBased pvb with(nolock) on pvb.Id = pv.ProductPricingValueBasedId
		where t.TranLocalDateTime >= '20200101'
		and TranType in (101, 103, 201, 203)
		AND DATEPART(HOUR, t.TranLocalDateTime)%12 = 1
		)

		SELECT cte.FNDiscount, dbo.F_GetFinanceDiscountAmount(cte.FinanceFormulaType, cte.FaceValue, cte.TranType, cte.TranAmount, cte.ProductType, cte.ValueBasedSoldPriceWithoutTax, cte.MultipleSelectionType, 'G')
		from cte

		SELECT @CurrentDateTime

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END
