
CREATE PROCEDURE spGetAdoraPieceEndVoucherNumberByOrderLine
    @OrderId INT ,
    @OrderLineId INT,
    @StartOrderLineSN INT,
    @EndOrderLineSN INT
AS
BEGIN
    select v.VoucherNumber, p.IdentityCode as ProgramCode
    from [dbo].[AdoraTask] adt with(nolock)
        JOIN [dbo].[VoucherOrder] vo with(nolock) on vo.AdoraTaskId = adt.Id and vo.OrderSN = adt.EndOrderSN
        JOIN [dbo].[Voucher] v with(nolock) on v.Id = vo.VoucherId
        JOIN [dbo].[Program] p with(nolock) on p.Id = v.ProgramId
    Where adt.Id in(
Select distinct( vo.AdoraTaskId)
    FROM [dbo].[VoucherOrder] vo with(nolock)
    WHERE vo.OrderId = @OrderId and vo.OrderLineId = @OrderLineId and (vo.OrderLineSN between @StartOrderLineSN and @EndOrderLineSN)
)
END
