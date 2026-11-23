CREATE PROCEDURE [order].[sp_upd_gr_file_status]
	@Id int,
	@Status int
AS
BEGIN
	SET XACT_ABORT ON;
	update [order].[tb_bf_batch_file] set [status] = @Status
	where id = @Id
END