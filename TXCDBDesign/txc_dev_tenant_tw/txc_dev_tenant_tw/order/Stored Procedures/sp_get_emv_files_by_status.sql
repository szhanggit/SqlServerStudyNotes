CREATE PROCEDURE [order].[sp_get_emv_files_by_status]
	@Status int
AS
BEGIN
	SET XACT_ABORT ON;
		select id,
		remote_location,
		file_name
		from [order].[tb_bf_batch_file] with(NOLOCK)
		where [status] = @Status
END