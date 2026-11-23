-- =============================================
-- Author:		Eagles Wang 
-- Create date: 2017/05/15
-- Description:	Get ImportTemplateId For Product
-- =============================================
CREATE PROCEDURE [dbo].[spGetImportTemplateIdForProduct]
	@ProgramId INT,
	@VoucherImportTemplateId INT OUTPUT
AS

BEGIN
	IF EXISTS (SELECT Id FROM VoucherImportTemplate
				WHERE ProgramId = @ProgramId)
	BEGIN
		SELECT @VoucherImportTemplateId = Id FROM VoucherImportTemplate
		WHERE ProgramId = @ProgramId
	END
	ELSE
	BEGIN
		SELECT @VoucherImportTemplateId = Id FROM VoucherImportTemplate
		WHERE ProgramId is Null
	END
	RETURN @VoucherImportTemplateId
END

