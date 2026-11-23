-- =============================================
-- Author:		Ritesh Varma
-- Create date: 09-Sept-2022
-- Description:	To insert the records for the voucher number rule Edenred Program
-- =============================================
CREATE PROCEDURE [merchant_info].[sp_ins_vouchernumber_rule] 
	(
	@merchantID int, 
	@voucherNumberPrefix varchar(15),
	@voucherNumberType int,
	@voucherNumberLength int,
	@pinType int=null,
	@displayVoucherNumberUnderBarcode bit,
	@barcodeTypeId int,
	@algorithmId int,
	@generatedBy int,
	@ruleName varchar(50),
	@displayText bit,
	@voucherNumberGenerator int=null,
	@createdby varchar(50),
	@voucherNumberRuleID int output,
	@Message varchar(500)='' output
	 
	)
AS
BEGIN
 
/** Check Rule Name Already Exists **/

If Exists (select * from [merchant_info].[tb_vnr_voucher_number_rule] where rule_name =trim(@ruleName))
Begin
 set @Message='Rule Name already exists';
 set @voucherNumberRuleID=0;
 select @Message,@voucherNumberRuleID
 return;
 
End

INSERT INTO [merchant_info].[tb_vnr_voucher_number_rule]
           ([voucher_number_prefix]
           ,[voucher_number_type]
           ,[voucher_number_length]
           ,[pin_type]
           ,[dist_voucher_num_under_barcode]
           ,[barcode_type_id]
           ,[algorithm_id]
           ,[CreatedBy]
           ,[CreatedDateTime]
           ,[merchant_id]
           ,[rule_name]
           ,[DisplayText]
           ,[voucher_number_generator]
           ,[generated_by]
		   ,[voucher_number_example]
		   )
     VALUES
           (@voucherNumberPrefix,
            @voucherNumberType,
            @voucherNumberLength,
            @pinType,
            @displayVoucherNumberUnderBarcode,
            @barcodeTypeId,
            @algorithmId,
            @createdby,
            GetUtcDate(),
            @merchantID,
            @ruleName,
            @displayText,
          	@voucherNumberGenerator ,
            @generatedBy,
			' '
			)
 

		    select @voucherNumberRuleID=SCOPE_IDENTITY();

END