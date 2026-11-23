-- =============================================
-- Author:		Homer
-- Create date: 2021-09-10
-- Description:	This stored procedure will get all the list of countries
-- =============================================
CREATE PROCEDURE [dbo].[sp_sel_ref_countries] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT country_code "CountryCode", country "Country", currency_symbol "CurrencySymbol" FROM tb_c_countries WHERE is_active = 1;
END