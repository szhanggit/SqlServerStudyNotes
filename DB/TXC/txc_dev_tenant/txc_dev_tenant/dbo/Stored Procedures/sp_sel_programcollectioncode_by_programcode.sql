CREATE PROCEDURE [dbo].[sp_sel_programcollectioncode_by_programcode]
	@ProgramCode [nvarchar](255),
	@TenantId [int]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT [program_collection_code] 'ProgramCollectionCode'
	FROM tb_pr_program_route
    WHERE program_code = @ProgramCode AND tenant_id = @TenantId
END