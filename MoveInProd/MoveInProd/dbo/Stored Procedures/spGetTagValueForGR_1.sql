
-- =============================================
-- Author:		<Author,Eagles>
-- Create date: <Create Date,2017-5-12>
-- Description:	<Description,GetTagValue For GR>
-- =============================================


CREATE PROCEDURE [dbo].[spGetTagValueForGR]
	@OrderLineId INT = null,
	@BeneficiaryInfoId BIGINT =null,
	@VoucherId BIGINT = null
AS
BEGIN
    IF(@OrderLineId is not null)
	Begin
		SELECT 
			v.id as id,
			gr.Ecode as ECode,
			gr.Vname as Vname,	
			gr.Denomination as Denomination,
			gr.Vcurrency as Vcurrency,
			gr.Vpassword as Vpassword,
			gr.Snumber as Snumber,
			gr.IssueDate as IssueDate,
			gr.ExpiryDate as ExpiryDate,
			gr.Vstatus as Vstatus,
			gr.FinBookingCurrency as FinBookingCurrency,
			gr.FinBookingValue as FinBookingValue,
			gr.URLExpiryPeriod,
			p.ProductCode as Itemsku,
			obfi.ClientOrderNumber as ClientOrderNumber,
			obfi.Name as RecipientName,
			obfi.VoucherQuantity,
			ISNULL(gr2.ProgramName, '') as ProgramName,
			ISNULL(gr2.GROrderID, '') as GROrderID,
			ISNULL(gr2.AwardBy, '') as AwardBy,
			ISNULL(gr2.SubProgram, '') as SubProgram,
			ISNULL(gr2.Misc1, '') as Misc1,
			ISNULL(gr2.Misc2, '') as Misc2,
			ISNULL(gr2.Misc3, '') as Misc3,
			ISNULL(gr.Misc1, '') AS TPCMisc1,
			ISNULL(gr.Misc2, '') AS TPCMisc2,
			ISNULL(p.VoucherSupplierId, '') AS VoucherSupplierId,
			ISNULL(pro.DateFormatString, '') as ProgramDateTimeFormatString
		FROM Voucher v
		INNER JOIN OrderBeneficiaryInfo obfi 
		ON v.BeneficiaryInfoId = obfi.Id
		INNER JOIN OrderLine ol
		ON obfi.OrderLineId = ol.Id
		LEFT JOIN EXT_GR_VoucherInfo gr
		ON v.ExtendId = gr.Id
		INNER JOIN Product p 
		ON v.ProductId = p.Id
		LEFT OUTER JOIN EXT_GR_OrderBeneficiaryInfo gr2
		ON obfi.Id = gr2.Id
		INNER JOIN Program pro
		ON p.ProgramId = pro.Id
		WHERE ol.Id = @OrderLineId

		Return
	End

    IF(@BeneficiaryInfoId is not null)
	Begin
		SELECT 
			v.id as id,
			gr.Ecode as ECode,
			gr.Vname as Vname,
			gr.Denomination as Denomination,
			gr.Vcurrency as Vcurrency,
			gr.Vpassword as Vpassword,
			gr.Snumber as Snumber,
			gr.IssueDate as IssueDate,
			gr.ExpiryDate as ExpiryDate,
			gr.Vstatus as Vstatus,
			gr.FinBookingCurrency as FinBookingCurrency,
			gr.FinBookingValue as FinBookingValue,
			gr.URLExpiryPeriod,
			p.ProductCode as Itemsku,
			obfi.ClientOrderNumber as ClientOrderNumber,
			obfi.Name as RecipientName,
			obfi.VoucherQuantity,
			ISNULL(gr2.ProgramName, '') as ProgramName,
			ISNULL(gr2.GROrderID, '') as GROrderID,
			ISNULL(gr2.AwardBy, '') as AwardBy,
			ISNULL(gr2.SubProgram, '') as SubProgram,
			ISNULL(gr2.Misc1, '') as Misc1,
			ISNULL(gr2.Misc2, '') as Misc2,
			ISNULL(gr2.Misc3, '') as Misc3,
			ISNULL(gr.Misc1, '') AS TPCMisc1,
			ISNULL(gr.Misc2, '') AS TPCMisc2,
			ISNULL(p.VoucherSupplierId, '') AS VoucherSupplierId,
			ISNULL(pro.DateFormatString, '') as ProgramDateTimeFormatString
		FROM Voucher v
		INNER JOIN OrderBeneficiaryInfo obfi 
		ON v.BeneficiaryInfoId = obfi.Id
		INNER JOIN OrderLine ol
		ON obfi.OrderLineId = ol.Id
		LEFT JOIN EXT_GR_VoucherInfo gr
		ON v.ExtendId = gr.Id
		INNER JOIN Product p 
		ON v.ProductId = p.Id
		LEFT OUTER JOIN EXT_GR_OrderBeneficiaryInfo gr2
		ON obfi.Id = gr2.Id
		INNER JOIN Program pro
		ON p.ProgramId = pro.Id
		WHERE obfi.Id = @BeneficiaryInfoId

		Return
	End

    IF(@VoucherId is not null)
	Begin
		SELECT 
			v.id as id,
			gr.Ecode as ECode,
			gr.Vname as Vname,
			gr.Denomination as Denomination,
			gr.Vcurrency as Vcurrency,
			gr.Vpassword as Vpassword,
			gr.Snumber as Snumber,
			gr.IssueDate as IssueDate,
			gr.ExpiryDate as ExpiryDate,
			gr.Vstatus as Vstatus,
			gr.FinBookingCurrency as FinBookingCurrency,
			gr.FinBookingValue as FinBookingValue,
			gr.URLExpiryPeriod,
			p.ProductCode as Itemsku,
			obfi.ClientOrderNumber as ClientOrderNumber,
			obfi.Name as RecipientName,
			obfi.VoucherQuantity,
			ISNULL(gr2.ProgramName, '') as ProgramName,
			ISNULL(gr2.GROrderID, '') as GROrderID,
			ISNULL(gr2.AwardBy, '') as AwardBy,
			ISNULL(gr2.SubProgram, '') as SubProgram,
			ISNULL(gr2.Misc1, '') as Misc1,
			ISNULL(gr2.Misc2, '') as Misc2,
			ISNULL(gr2.Misc3, '') as Misc3,
			ISNULL(gr.Misc1, '') AS TPCMisc1,
			ISNULL(gr.Misc2, '') AS TPCMisc2,
			ISNULL(p.VoucherSupplierId, '') AS VoucherSupplierId,
			ISNULL(pro.DateFormatString, '') as ProgramDateTimeFormatString
		FROM Voucher v
		INNER JOIN OrderBeneficiaryInfo obfi 
		ON v.BeneficiaryInfoId = obfi.Id
		INNER JOIN OrderLine ol
		ON obfi.OrderLineId = ol.Id
		LEFT JOIN EXT_GR_VoucherInfo gr
		ON v.ExtendId = gr.Id
		INNER JOIN Product p 
		ON v.ProductId = p.Id
		LEFT OUTER JOIN EXT_GR_OrderBeneficiaryInfo gr2
		ON obfi.Id = gr2.Id
		INNER JOIN Program pro
		ON p.ProgramId = pro.Id
		WHERE v.Id = @VoucherId

		Return
	End

END

