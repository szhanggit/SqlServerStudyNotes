
CREATE PROCEDURE spGetAdoraPieceEndVoucherNumberByOrderLineBuffer
    @OrderId INT ,
    @OrderLineId INT,
    @StartOrderLineSN INT,
    @EndOrderLineSN INT
AS
BEGIN
    select v.VoucherNumber, p.IdentityCode as ProgramCode
    from [dbo].[AdoraTask] adt with(nolock)
        JOIN [dbo].[VoucherOrderBuffer] vo with(nolock) on vo.AdoraTaskId = adt.Id and vo.OrderSN = adt.EndOrderSN
        JOIN [dbo].[VoucherBuffer] v with(nolock) on v.Id = vo.VoucherId
        JOIN [dbo].[Program] p with(nolock) on p.Id = v.ProgramId
    Where adt.Id in(
Select distinct( vo.AdoraTaskId)
    FROM [dbo].[VoucherOrderBuffer] vo with(nolock)
    WHERE vo.OrderId = @OrderId and vo.OrderLineId = @OrderLineId and (vo.OrderLineSN between @StartOrderLineSN and @EndOrderLineSN)
)
END
