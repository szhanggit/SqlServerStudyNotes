-- =============================================
-- Author:		Rohit Singh
-- Create date: 09-Sept-2022
-- Description:	To Update the records for the voucher number rule Third Party
-- Modified On : 06-10-2022 
-- Description : If their is not change in rule Name update must allow to update other fields as well.
-- =============================================
--Update Voucher Number Rule Third Party
CREATE PROCEDURE [merchant_info].[sp_upt_vouchernumber_rule_third_party]
	(
	 @pinType TINYINT = null
	,@displayVoucherNumberUnderBarcode BIT
	,@barcodeTypeId TINYINT
	,@ruleName NVARCHAR(50)
	,@requestExpiryDate BIT
	,@hasMultipartBarcode BIT
	,@onDemand BIT
	,@voucherNumberRuleID INT
	,@updatedBy NVARCHAR(50)
	,@voucherNumberRuleIdOutput INT OUTPUT
	)
AS
BEGIN
IF EXISTS (SELECT 1 FROM [merchant_info].[tb_vnr_voucher_number_rule] WHERE 
	TRIM(REPLACE(LOWER(rule_name),' ','')) = TRIM(REPLACE(LOWER(@ruleName),' ',''))
	AND id<> @voucherNumberRuleID
	)
BEGIN
 SET @voucherNumberRuleIDOutput=0;
 SELECT @voucherNumberRuleIdOutput
 RETURN; 
END

UPDATE [merchant_info].[tb_vnr_voucher_number_rule] 
SET
	pin_type = @pinType,
	dist_voucher_num_under_barcode = @displayVoucherNumberUnderBarcode,
	barcode_type_id = @barcodeTypeId,
	rule_name = @ruleName,
	request_expiry_date = @requestExpiryDate,
	has_multipart_barcode = @hasMultipartBarcode,
	on_demand = @onDemand,
	updated_by = @updatedBy,
	updated_on = GETUTCDATE()
WHERE id = @voucherNumberRuleID

SET @voucherNumberRuleIdOutput = @voucherNumberRuleID
SELECT  @voucherNumberRuleIdOutput
END