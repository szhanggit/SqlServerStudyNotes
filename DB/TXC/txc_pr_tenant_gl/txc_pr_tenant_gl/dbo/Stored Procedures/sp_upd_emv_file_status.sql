CREATE PROCEDURE [dbo].[sp_upd_emv_file_status]
	@Id int,
	@Status int
AS
BEGIN
	SET XACT_ABORT ON;
	update [dbo].[tb_bf_batch_file] set [status] = @Status
	where id = @Id
END