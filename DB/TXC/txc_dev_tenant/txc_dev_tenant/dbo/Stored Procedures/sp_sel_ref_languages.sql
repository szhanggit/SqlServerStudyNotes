-- =============================================
-- Author:		Homer R. Sumabat
-- Create date: 2021-09-10
-- Description:	This stored procedure will get all the list of languages
-- =============================================
CREATE PROCEDURE [dbo].[sp_sel_ref_languages]	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT language_id "LanguageId", [language] "Language" FROM tb_l_languages where is_active = 1;
END