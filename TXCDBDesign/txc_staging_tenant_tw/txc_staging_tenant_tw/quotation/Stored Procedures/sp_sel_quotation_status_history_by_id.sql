CREATE PROCEDURE [quotation].[sp_sel_quotation_status_history_by_id]
	@Id	int
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;

    BEGIN TRY
		
		SELECT * FROM [quotation].[tb_qsh_quotation_status_history] with(nolock) WHERE quotation_id = @Id
				 			 
    END TRY
    BEGIN CATCH 
		THROW
    END CATCH;
	
	SET NOCOUNT, XACT_ABORT OFF;

END