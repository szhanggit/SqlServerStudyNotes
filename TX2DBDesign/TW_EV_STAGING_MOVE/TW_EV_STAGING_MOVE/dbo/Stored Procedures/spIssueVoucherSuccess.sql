
-- =============================================
-- Author:		Knight YAO
-- Create date: 2015/07/03
-- Description:	Set property after issue voucher success.
-- =============================================
CREATE PROCEDURE [dbo].[spIssueVoucherSuccess]
	@OrderBeneficiaryInfoId		BIGINT
AS
BEGIN
	UPDATE Voucher
	SET [Status] = 1,
	    PublishedOn = GETDATE()
	WHERE BeneficiaryInfoId = @OrderBeneficiaryInfoId
END
