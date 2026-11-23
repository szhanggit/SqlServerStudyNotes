-- =============================================
-- Author:		Homer R. Sumabat
-- Create date: 2021-09-10
-- Description:	This stored procedure will get all the time_format
-- =============================================
CREATE PROCEDURE [dbo].[sp_sel_ref_time_format]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT time_format_id "TimeFormatId",time_format "TimeFormat" FROM tb_tf_time_format WHERE is_active = 1;
END