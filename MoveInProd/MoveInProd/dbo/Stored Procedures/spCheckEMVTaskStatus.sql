
CREATE PROCEDURE spCheckEMVTaskStatus
    @TaskId INT
AS
BEGIN
    DECLARE @Status TINYINT

    Select @Status = min(co.Status)
    FROM [dbo].[EMV_ClientOrderTaskDetail] ctod
        join [dbo].[EMV_ClientOrderLine] col on col.Id = ctod.ClientOrderLineId
        join [dbo].[EMV_ClientOrder] co on co.Id = col.ClientOrderId
    where ctod.ClientOrderTaskId = @TaskId

    if EXISTS(select 1
    from [dbo].[EMV_ClientOrderTask]
    where Id = @TaskId and [Status]<@Status)
BEGIN

        UPDATE [dbo].[EMV_ClientOrderTask] set [Status] = @Status where Id = @TaskId

    END

END
