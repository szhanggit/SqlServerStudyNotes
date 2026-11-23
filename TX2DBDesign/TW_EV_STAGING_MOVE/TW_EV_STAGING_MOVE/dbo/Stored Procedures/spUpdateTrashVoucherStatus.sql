create proc spUpdateTrashVoucherStatus @VoucherId bigint, @Status int
as
begin
	set nocount on;

	update TrashVoucherLog set TrashStatus = @Status where VoucherId = @VoucherId;
end

