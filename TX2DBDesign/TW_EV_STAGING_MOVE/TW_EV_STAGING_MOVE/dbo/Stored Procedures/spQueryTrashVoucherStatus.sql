create proc spQueryTrashVoucherStatus @VoucherId bigint
as
begin
	set nocount on;

	declare @trashStatus int = null
	select @trashStatus = TrashStatus from TrashVoucherLog where VoucherId = @VoucherId;

	if @trashStatus is null
	begin
		insert TrashVoucherLog(VoucherId,TrashStatus) values(@VoucherId,1);
		select 1;
	end
	else
		select @trashStatus;
end
