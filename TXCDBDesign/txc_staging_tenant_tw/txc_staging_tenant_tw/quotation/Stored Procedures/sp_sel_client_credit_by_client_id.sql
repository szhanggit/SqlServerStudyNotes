CREATE PROCEDURE [quotation].[sp_sel_client_credit_by_client_id]
	@ClientId	int
AS
BEGIN

	SET NOCOUNT ON;

	SELECT 
		client_id "ClientId", 
		credit_limit "CreditLimit", 
		available_credit "AvailableCredit", 
		parkfund "Parkfund", 
		client_email "ClientEmail", 
		extend_email "ExtendEmail", 
		modify_version "ModifyVersion"
	FROM [quotation].[tb_cc_client_credit]
	WHERE client_id = @ClientId

END