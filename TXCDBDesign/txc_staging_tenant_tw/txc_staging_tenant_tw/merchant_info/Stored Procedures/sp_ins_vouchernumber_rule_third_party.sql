-- =============================================
-- Author:		Rohit Singh
-- Create date: 09-Sept-2022
-- Description:	To insert the records for the voucher number rule Third Party
-- Updated on : 21-Sept-2022
--	Purpose : Implement Validation on Rule Name, check if already exists.
-- =============================================
--Insert Voucher Number Rule Third Party
CREATE PROCEDURE [merchant_info].[sp_ins_vouchernumber_rule_third_party]
	(
	 @pinType TINYINT
	,@displayVoucherNumberUnderBarcode BIT
	,@barcodeTypeId TINYINT
	,@generatedBy VARCHAR(50)
	,@merchantId INT
	,@ruleName NVARCHAR(50)
	,@requestExpiryDate BIT
	,@hasMultipartBarcode BIT
	,@onDemand BIT
	,@createdBy VARCHAR(50)
	,@voucherNumberRuleID INT OUTPUT
	)
AS
BEGIN
If EXISTS (SELECT 1 FROM [merchant_info].[tb_vnr_voucher_number_rule] WHERE TRIM(REPLACE(LOWER(rule_name),' ','')) = TRIM(REPLACE(LOWER(@ruleName),' ','')))
BEGIN
 SET @voucherNumberRuleID=0;
 SELECT @voucherNumberRuleID
 RETURN; 
END

INSERT INTO [merchant_info].[tb_vnr_voucher_number_rule]
	(
		pin_type,
		dist_voucher_num_under_barcode,
		barcode_type_id,
		generated_by,
		merchant_id,
		rule_name,
		request_expiry_date,
		has_multipart_barcode,
		on_demand,
		CreatedBy,
		---------------------------
		voucher_number_type,
		voucher_number_length,
		voucher_number_example,
		algorithm_id,
		CreatedDateTime,
		voucher_number_generator

		   )
     VALUES
	(
		@pinType
		,@displayVoucherNumberUnderBarcode
		,@barcodeTypeId
		,@generatedBy
		,@merchantId
		,@ruleName
		,@requestExpiryDate
		,@hasMultipartBarcode
		,@onDemand
		,@createdBy
		-------------------------------
		,2
		,10
		,''
		,1
		,GETUTCDATE()
		,1
			)
	SET @voucherNumberRuleID = SCOPE_IDENTITY();
END