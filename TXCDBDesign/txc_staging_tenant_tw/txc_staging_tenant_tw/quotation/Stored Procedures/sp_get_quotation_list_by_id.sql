CREATE PROCEDURE quotation.sp_get_quotation_list_by_id
	@TvpGetQuotationListByIds quotation.tvp_get_quotation_list_by_id readonly

AS
BEGIN
	SET XACT_ABORT ON;
	
	SELECT q1.[id] "Id"
		  ,[client_id] "ClientId"
		  ,[quotation_number] "QuotationNumber"
		  ,[valid_from] "ValidFrom"
		  ,[valid_to] "ValidTo"
		  ,[project_code] "ProjectCode"
		  ,[project_name] "ProjectName"
		  ,[quotation_type] "QuotationType"
		  ,[business_model_id] "BusinessModelId"
		  ,[sales] "Sales"
		  ,[contact_name] "ContactName"
		  ,[contact_position] "ContactPosition"
		  ,[contact_phone] "ContactPhone"
		  ,[contact_email] "ContactEmail"
		  ,[status] "Status"
		  ,[business_type_id] "BusinessTypeId"
		  ,[end_client_id] "EndClientId"
		  ,[campaign_type1_id] "CampaignType1Id"
		  ,[campaign_type2_id] "CampaignType2Id"
		  ,[service_fee_type] "ServiceFeeType"
		  ,[ignore_issue_number_limit] "IgnoreIssueNumberLimit"
		  ,[finance_email] "FinanceEmail"
		  ,[updated_on] "UpdatedOn"
		  ,[sub_business_model_id] "SubBusinessModelId"
		  ,[finance_expire_days] "FinanceExpireDays"
		  ,[created_by_system] "CreatedBySystem"
		  ,[email_header_logo_id] "EmailHeaderLogoId"
		  ,[email_footer_logo_id] "EmailFooterLogoId"
		  ,[IN_business_model] "INBusinessModel"
		  ,[teasers_type_id] "TeasersTypeId"
		  ,[teasers_type_note] "TeasersTypeNote"
		  ,[teasers_owner_id] "TeasersOwnerId"
		  ,[teasers_owner_note] "TeasersOwnerNote"
		  ,[enable_wallet_link] "EnableWalletLink"
		  ,[wallet_group_by] "WalletGroupBy"
		  ,[advance_billing] "AdvanceBilling"
		  ,[billing_frequency] "BillingFrequency"
		  ,[billing_date] "BillingDate"
		  ,[payment_term] "PaymentTerm"
		  ,[BBX_advance_billing] "BBXAdvanceBilling"
		  ,[auto_create_billing] "AutoCreateBilling"
		  ,[sales_email] "SalesEmail"
		  ,[is_created_fapaio] "IsCreatedFapaio"
		  ,[is_BBX_advanced_billing] "IsBBXAdvancedBilling"
		  ,[is_auto_create_fapaio] "IsAutoCreateFapaio"
		  ,[BBX_advancedB_billing_number] "BBXAdvancedBillingNumber"
		  ,[auto_create_fapaio_number] "AutoCreateFapaioNumber"
		  ,[advanced_billing_off_reason] "AdvancedBillingOffReason"
	  FROM [quotation].[tb_q_quotation] q1
	  INNER JOIN @TvpGetQuotationListByIds q2 ON q1.id = q2.QuotationId
	  LEFT JOIN [quotation].tb_qb_quotation_billing qb ON q1.id = qb.quotation_id

END